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

import sys,cgi
import MySQLdb

config = {
    'dbname':       "httpd_logs",
    'dbuser':       "httpd_log",
    'dbpass':       "abc123",
    'access_tab':   "access_log",
}

sql = {
    'total_entries':
        """ SELECT COUNT(*) 
            FROM %(access_tab)s 
            WHERE virtual_host="%(vhost)s"
        """,

    'bytes_sent':
        """ SELECT SUM(bytes_sent) 
            FROM %(access_tab)s 
            WHERE virtual_host="%(vhost)s"
        """,

    'distinct_uris':
        """ SELECT request_uri
            FROM %(access_tab)s
            WHERE status=200 
            AND virtual_host="%(vhost)s"
            GROUP BY request_uri
        """,

    'distinct_rhosts':
        """ SELECT remote_host
            FROM %(access_tab)s
            WHERE status=200
            AND virtual_host="%(vhost)s"
            GROUP BY remote_host
        """,
}


def html_header():
    return """Content-Type: text/html

<html>
<head>
<title>Test</title>
</head>

<body style="background: white">
"""

def html_footer():
    return """
</body>
</html>
"""

def db_conn():
    conn = MySQLdb.connect(db=config['dbname'], user=config['dbuser'],
        passwd=config['dbpass'])
    return conn

def rpt_summary(c):
    rpt = {}

    c.execute(sql['total_entries'] % config)
    rpt['total_entries'] = c.fetchone()[0]

    c.execute(sql['bytes_sent'] % config)
    rpt['bytes_sent'] = c.fetchone()[0]

    # Stupid MySQL doesn't support sub-queries
    r = c.execute(sql['distinct_uris'] % config)
    rpt['distinct_uris'] = r

    r = c.execute(sql['distinct_rhosts'] % config)
    rpt['distinct_rhosts'] = r

    s = """
        <br><b>Analysed %(total_entries)d log entries.</b>
        <br><b>Tranferred %(bytes_sent)d bytes.</b>
        <br><b>Served %(distinct_uris)d distinct URIs.</b>
        <br><b>Served %(distinct_rhosts)d distinct remote hosts.</b>
        """ % rpt

    return s


if __name__ == '__main__':
    dbconn = db_conn()
    cursor = dbconn.cursor()
    config['vhost'] = 'haus.nakedape.cc'

    print html_header()
    print "<h1>Stuff</h1>"
    print rpt_summary(cursor)
    print html_footer()

# vim: set ft=python
