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
        self.timing_re = rc(r'^.*total (\d+) .*$')
        self.spam_tag_re = rc(r'(Yes|No), hits=([^\s]*) ')
        self.regex_map = {
            rc('amavis.*TIMING '): self.msg_timing,
            rc('amavis.*SPAM(|-TAG), '): self.spam_tag,
        }

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

    def finalize(self, resultset):
        if self.spam_total != 0:
            spam_avg = self.spam_score_total/self.spam_total
        else:
            spam_avg = 0

        if self.ham_total != 0:
            ham_avg = self.ham_score_total/self.ham_total
        else:
            ham_avg = 0

        if self.ham_total != 0:
            spam_percent = 100.0 * self.spam_total / self.ham_total

        report = """
        <table border="0" width="100%%" rules="cols"
            cellpadding="2">
        <tr><th colspan="2" align="left">
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
        <!--
        </table>

        <table border="0" width="100%%" rules="cols"
            cellpadding="2"> -->

        <tr><th colspan="2" align="left">
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
            <td>Average score of ham messages</td>
            <td><b>%0.2f</b></td>
        </tr>
        <tr>
            <td>Percentage of messages identified as spam</td>
            <td><b>%0.2f%%</b></td>
        </tr>
        </table>
        
        """ % \
            (self.total_msgs, 
                self.total_time/1000.0, 
                self.total_time/self.total_msgs/1000.0,
                self.max_time_msg/1000.0,
                self.excess_time_floor/1000,
                self.excess_time_cnt,
                self.spam_total,
                spam_avg,
                self.ham_total,
                ham_avg,
                spam_percent,
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
