#!/usr/bin/python2 -tt
import sys
import re

rc = re.compile
sys.path.insert(0, '../py/')
from epylog import InternalModule

class amavis_mod(InternalModule):
    def __init__(self, opts, logger):
        InternalModule.__init__(self)
        self.logger = logger
        self.total_msgs = 0
        self.total_score = 0
        self.total_time = 0.0
        self.excess_time_cnt = 0
        self.max_time_msg = 0.0
        self.excess_time_floor = 45 * 1000
        self.ham_total = 0
        self.spam_total = 0
        self.ham_score_total = 0.0
        self.spam_score_total = 0.0
        self.infected_cnt = 0
        self.banned_cnt = 0
        self.banned_types = {}
        self.recip_domains = {}

        self.timing_re = rc(r'^.*total (\d+) .*$')
        self.spam_tag_re = rc(r'(Yes|No), hits=([^\s]*) ')
        self.banned_type_re = rc(r'BANNED name/type \((.*)\)')
        self.recip_re = rc(r'-> \<([^@]+)@([^@]+)\>')

        self.regex_map = {
            rc('amavis.*TIMING '): self.msg_timing,
            rc('amavis.*SPAM(|-TAG), '): self.spam_tag,
            rc('amavis.*INFECTED '): self.infected_tag,
            rc('amavis.*BANNED '): self.banned_tag,
            rc('amavis.*FWD '): self.recip_summ,
        }

    def extract_recip_email(self, str):
        """ Given a log entry with form: <sender> -> <recipient>, 
            extract the LHS and RHS of the recipient"""

        m = self.recip_re.search(str)
        if m is not None:
           return (m.group(1), m.group(2))
        else:
           return (None, None)

    def recip_summ(self, linemap):
        """ Builds a dictionary of domains (RHS), where each
            value is a dictionary containing { lhs: count }"""
        (lhs, dom) = self.extract_recip_email(linemap['message'])
        doms = self.recip_domains

        if dom is not None:
            if doms.has_key(dom):
                if doms[dom].has_key(lhs):
                    doms[dom][lhs] += 1
                else:
                    doms[dom][lhs] = 1
            else:
                doms[dom] = { lhs: 1 }

        return {('x'): linemap['multiplier']}

    def msg_timing(self, linemap):
        m = self.timing_re.search(linemap['message'])
        if m is not None:
            t = float(m.group(1))
            self.total_time += t
            self.total_msgs += 1
            if t > self.max_time_msg: self.max_time_msg = t
            if t > self.excess_time_floor: self.excess_time_cnt += 1

        return {('x'): linemap['multiplier']}

    def spam_tag(self, linemap):
        m = self.spam_tag_re.search(linemap['message'])
        if m is not None:
            spambool = m.group(1)
            score = float(m.group(2))

            if spambool == 'Yes':
                self.spam_total += 1
                self.spam_score_total += score
            else:
                self.ham_total += 1
                self.ham_score_total += score

        return {('x'): linemap['multiplier']}

    def infected_tag(self, linemap):
        self.infected_cnt += 1

    def banned_tag(self, linemap):
        self.banned_cnt += 1
        m = self.banned_type_re.search(linemap['message'])
        if m is not None:
            bt = m.group(1)
            if self.banned_types.has_key(bt):
                self.banned_types[bt] += 1
            else:
                self.banned_types[bt] = 1

    def timing_report(self):
        report = """
        <tr>
            <th colspan="2" align="left">
                <h3 style="color: blue">Timing Report</h3>
            </th>
        </tr>
        <tr>
            <td>Total time for processing <b>%d</b> messages</td>
            <td><b>%0.2f secs</b></td>
        </tr>
        <tr>
            <td>Average time</td>
            <td><b>%0.2f secs</b></td>
        </tr>
        <tr>
            <td>Maximum time</td>
            <td><b>%0.2f secs</b></td>
        </tr>
        <tr>
            <td>Messages in excess of %d secs</td>
            <td><b>%d</b></td>
        </tr>
        """ % (
            self.total_msgs, 
            self.total_time/1000.0, 
            self.total_time/self.total_msgs/1000.0,
            self.max_time_msg/1000.0,
            self.excess_time_floor/1000,
            self.excess_time_cnt,
        )

        return report

    def banned_types_report(self):
        report = """
        <tr>
            <th colspan="2" align="left">
                <h3 style="color: blue">Banned File Report</h3>
            </th>
        </tr>

        <tr>
            <td>Number of banned file types</td>
            <td><b>%d</b></td>
        </tr>

        <tr>
            <th>Banned File Type</th>
            <th align="left">Count</th>
        </tr>
        """ % (self.banned_cnt)

        for bt in self.banned_types:
            report += """
        <tr>
            <td>%s</td>
            <td>%s</td>
        </tr>""" % (bt, self.banned_types[bt])

        return report

    def spam_report(self):
        if self.spam_total != 0:
            spam_avg = self.spam_score_total/self.spam_total
        else:
            spam_avg = 0

        if self.ham_total != 0:
            ham_avg = self.ham_score_total/self.ham_total
        else:
            ham_avg = 0

        if self.ham_total != 0:
            spam_percent = 100.0 * self.spam_total / self.total_msgs

        report = """
        <tr>
            <th colspan="2" align="left">
                <h3 style="color: blue">Spam Report</h3>
            </th>
        </tr>
        <tr>
            <td>Number of spam messages</td>
            <td><b>%d</b></td>
        </tr>
        <tr>
            <td>Average score of spam messages</td>
            <td><b>%0.2f</b></td>
        </tr>
        <tr>
            <td>Number of non-spam messages</td>
            <td><b>%d</b></td>
        </tr>
        <tr>
            <td>Average score of non-spam messages</td>
            <td><b>%0.2f</b></td>
        </tr>
        <tr>
            <td>Percentage of messages identified as spam</td>
            <td><b>%0.2f%%</b></td>
        </tr>
        """ % (
            self.spam_total,
            spam_avg,
            self.ham_total,
            ham_avg,
            spam_percent,
        )

        return report

    def virus_report(self):
        report = """
        <tr>
            <th colspan="2" align="left">
                <h3 style="color: blue">Virus Report</h3>
            </th>
        </tr>

        <tr>
            <td>Number of infected messages</td>
            <td><b>%d</b></td>
        </tr>
        """ % (self.infected_cnt)

        return report

    def domain_recip_report(self):
        doms = self.recip_domains

        report = """
        <tr>
            <th colspan="2" align="left">
                <h3 style="color: blue">Domain Recipient Report</h3>
            </th>
        </tr>
        <tr>
            <td>Total number of domains serviced</td>
            <td><b>%d</b></td>
        </tr>
        <tr>
            <th>Domain</th>
            <th>Total Recipients</th>
        </tr>
        """ % len(doms)

        for dom in doms:
            report += """
        <tr>
            <td>%s</td>
            <td>%d</td>
        </tr>
        """ % (dom, len(doms[dom]))

        return report


    def finalize(self, resultset):

        report = """
        <table border="0" width="100%%" rules="cols" cellpadding="2">
        %s
        %s
        %s
        %s
        %s
        </table>
        """ % (self.timing_report(),
            self.spam_report(),
            self.virus_report(),
            self.banned_types_report(),
            self.domain_recip_report(),
            )

        return report

##
# This is useful when testing your module out.
# Invoke without command-line parameters to learn about the proper
# invocation.
#
if __name__ == '__main__':
    from epylog.helpers import ModuleTest
    ModuleTest(amavis_mod, sys.argv)
