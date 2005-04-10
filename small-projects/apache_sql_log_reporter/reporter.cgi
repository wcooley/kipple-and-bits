#!/usr/bin/env python
#
# Written by: Wil Cooley <wcooley@nakedape.cc>
# Begun: 29 Feb 2004
#
# Name: reporter.cgi
# Description: CGI script to make reports from Apache logs stored in MySQL
#   using mod_log_sql.
#
# $Id$

import sys, cgi, time, socket

# Local stuff
import sql
from config import config

_known_bots = [ "Googlebot", "Ask Jeeves", "Yahoo", 
    "fmII URL validator", "appie", "NPBot"
    ]

def html_header():
    return """Content-Type: text/html

<html>
<head>
<title>Apache Log Report</title>
</head>

<body style="background: white">
<h1>Apache Log Report</h1>
"""

def html_navbar():
    return """
[
<a href="#rpt_summary">Summary</a> |
<a href="#rpt_referer">Top Referers</a> |
<a href="#rpt_request">Top Requests</a> |
<a href="#rpt_requestor">Top Requestors</a> |
<a href="#rpt_error_request">Top Error Requests</a> |
<a href="#rpt_error_requestor">Top Error Requestors</a> |
<a href="#rpt_bot_request">Bot Requests</a>
]
"""

def html_footer():
    return """
</body>
</html>
"""

def resolve_hostname(addr):
    """ resolve_hostname - Quick and dirty hostname lookups.  If it's too
    slow, rewrite to be parallel or async or something."""
    try:
        name = socket.gethostbyaddr(addr)
    except socket.error:    # FIXME: Be more specific; 
                            #   only catch 'host not found'
        name = addr
    else:
        name = name[0]

    return name


def rpt_summary(q):
    rpt = {}
    rpt['vhost'] = config['vhost']

    rpt['total_entries'] = q.total_entries()
    rpt['bytes_sent'] = q.bytes_sent()
    rpt['mbytes_sent'] = int (q.bytes_sent() / (1024 * 1024))
    rpt['distinct_uris'] = q.distinct_uris()
    rpt['distinct_rhosts'] = q.distinct_rhosts()
    rpt['date_begin'] = q.date_begin()
    rpt['date_end'] = q.date_end()

    s = """
        <h2><a name="rpt_summary">Summary</a></h2>
        <br />Analysed <b>%(total_entries)d</b> log entries for host <b>%(vhost)s</b>.
        <br />Tranferred <b>%(bytes_sent)d</b> bytes (%(mbytes_sent)d MB).
        <br />Served <b>%(distinct_uris)d</b> distinct URIs.
        <br />Served <b>%(distinct_rhosts)d</b> distinct remote hosts.
        <br />Logs begin <b>%(date_begin)s</b>.
        <br />Logs end <b>%(date_end)s</b>.
        <hr /> """ % rpt

    return s

def rpt_referer(q, lim):
    s = """
        <h2><a name="rpt_referer">Referers</a></h2>
        <table>
        <tr>
            <th>Count</th>
            <th>Referer</th>
        </tr> """
    for row in q.top_referers(lim):
        s = s + """
        <tr>
            <td>%d</td>
            <td>%s</td>
        </tr> """ % (row)

    s = s + """
        </table>
        <hr />
        """

    return s

def rpt_request(q, lim):
    s = """
        <h2><a name="rpt_request">Top Requests</a></h2>
        <table>
        <tr>
            <th>Count</th>
            <th>Request</th>
        </tr> """
    for row in q.top_request(lim):
        s = s + """
        <tr>
            <td>%d</td>
            <td>%s</td>
        </tr> """ % (row)

    s = s + """
        </table>
        <hr />
        """

    return s

def rpt_requestor(q, lim):
    s = """
        <h2><a name="rpt_requestor">Top Requestors</a></h2>
        <table>
        <tr>
            <th>Count</th>
            <th>Requestor</th>
        </tr>
        """
    for row in q.top_requestor(lim):
        s = s + """
        <tr>
            <td>%d</td>
            <td>%s</td>
        </tr> """ % (row[0], resolve_hostname(row[1]))

    s = s + """
        </table>
        <hr />
        """

    return s

def rpt_error_request(q, lim):
    s = """
        <h2><a name="rpt_error_request">Top Error Requests</a></h2>
        <table>
        <tr>
            <th>Count</th>
            <th>Request</th>
        </tr>"""

    for row in q.top_error_request(lim):
        s = s + """
        <tr>
            <td>%d</td>
            <td>%s</td>
        </tr> """ % (row)

    s = s + """
        </table>
        <hr />
        """

    return s


def rpt_error_requestor(q, lim):
    s = """
        <h2><a name="rpt_error_requestor">Top Error Requestors</a></h2>
        <table>
        <tr>
            <th>Count</th>
            <th>Requestor</th>
        </tr>"""

    for row in q.top_error_requestor(lim):
        s = s + """
        <tr>
            <td>%d</td>
            <td>%s</td>
        </tr> """ % (row[0], resolve_hostname(row[1]))

    s = s + """
        </table>
        <hr />
        """

    return s

def rpt_bot_request(q):

    s = """
        <h2><a name="rpt_bot_request">Bot Requests</a></h2>
        <table>
        <tr>
            <th>Bot</th>
            <th>Count</th>
        </tr>"""

    for bot in _known_bots:
        s = s + """
        <tr>
            <td>%s</td>
            <td>%d</td>
        </tr>""" % (bot, q.bot_request(bot))

    s = s + """
        </table>
        <hr />
        """

    return s


if __name__ == '__main__':
    query = sql.ReportQuery()
    lim = 20

    print html_header()
    print html_navbar()
    print rpt_summary(query)
    print html_navbar()
    print rpt_referer(query, lim)
    print html_navbar()
    print rpt_request(query, lim)
    print html_navbar()
    print rpt_requestor(query, lim)
    print html_navbar()
    print rpt_error_request(query, lim)
    print html_navbar()
    print rpt_error_requestor(query, lim)
    print html_navbar()
    print rpt_bot_request(query)
    print html_footer()

# vim: set ft=python
