#!/usr/bin/env python
#
# Written by: Wil Cooley <wcooley@nakedape.cc>
# Begun: 06 Mar 2004
#
# Name: sql.py
# Description: Contains SQL strings used by reporter.cgi
#
# $Id$
#

import time
import MySQLdb
from config import config

_time_fmt = "%a, %d %b %Y %H:%M:%S"

class ReportQuery:

    def __init__(self):
        self.cur = self.dbcursor()
        self._total_entries = None
        self._bytes_sent = None
        self._distinct_uris = None
        self._distinct_rhosts = None
        self._date_begin = None
        self._date_end = None
        self._top_referers = None
        self._top_referers_lim = 0
        self._top_request = None
        self._top_request_lim = 0
        self._top_requestor = None
        self._top_requestor_lim = 0
        self._top_error_request = None
        self._top_error_request_lim = 0
        self._top_error_requestor = None
        self._top_error_requestor_lim = 0
        self._status = {}
        self._bot = {}

    def dbcursor(self):
        """ Connects to the MySQL database and gets a cursor.
            Returns: Cursor
        """

        conn = MySQLdb.connect(db=config['dbname'], user=config['dbuser'],
            passwd=config['dbpass'], host=config['dbhost'])

        cursor = conn.cursor()
        return cursor

    def total_entries(self):
        q = """
        SELECT COUNT(*) 
        FROM %(access_tab)s 
        WHERE virtual_host="%(vhost)s" """ % config

        if self._total_entries is None:
            self.cur.execute(q)
            self._total_entries = self.cur.fetchone()[0]

        return self._total_entries

    def bytes_sent(self): 
        q = """ 
        SELECT SUM(bytes_sent) 
        FROM %(access_tab)s 
        WHERE virtual_host="%(vhost)s" """ % config

        if self._bytes_sent is None:
            self.cur.execute(q)
            self._bytes_sent = self.cur.fetchone()[0]

        return self._bytes_sent

    def distinct_uris(self): 
        q = """
        SELECT request_uri
        FROM %(access_tab)s
        WHERE status=200 
        AND virtual_host="%(vhost)s"
        GROUP BY request_uri """ % config

        if self._distinct_uris is None:
            self._distinct_uris = self.cur.execute(q)

        return self._distinct_uris

    def distinct_rhosts(self): 
        q = """ 
        SELECT remote_host
        FROM %(access_tab)s
        WHERE status=200
        AND virtual_host="%(vhost)s"
        GROUP BY remote_host """ % config

        if self._distinct_rhosts is None:
            self._distinct_rhosts = self.cur.execute(q)

        return self._distinct_rhosts

    def date_begin(self): 
        q = """ 
        SELECT time_stamp
        FROM %(access_tab)s
        WHERE virtual_host="%(vhost)s"
        ORDER BY time_stamp ASC
        LIMIT 1 """ % config

        if self._date_begin is None:
            self.cur.execute(q)
            r = self.cur.fetchone()[0]
            self._date_begin = time.strftime(_time_fmt, time.localtime(r))

        return self._date_begin

    def date_end(self): 
        q = """
        SELECT time_stamp
        FROM %(access_tab)s
        WHERE virtual_host="%(vhost)s"
        ORDER BY time_stamp DESC
        LIMIT 1 """ % config

        if self._date_end is None:
            self.cur.execute(q)
            r = self.cur.fetchone()[0]
            self._date_end = time.strftime(_time_fmt, time.localtime(r))

        return self._date_end

    def top_referers(self, lim): 
        """ top_referers - Queries top /lim/ referring hosts.
            Returns a list of lists of width two.  The first element is
            the count and the second the URI of the referer.
        """
        q = """
        SELECT COUNT(referer) c, referer
        FROM %(access_tab)s 
        WHERE virtual_host="%(vhost)s"
            AND referer != "-"
            AND referer NOT LIKE "%%%(vhost)s%%"
        GROUP BY referer
        ORDER BY c DESC
        LIMIT %(limit)d """ % {
            'access_tab': config['access_tab'],
            'vhost': config['vhost'],
            'limit': lim,
            }

        if self._top_referers is None or self._top_referers_lim != lim:
            self._top_referers_lim = lim
            self.cur.execute(q)
            self._top_referers = self.cur.fetchall()

        return self._top_referers

    def top_request(self, lim):
        q = """
        SELECT COUNT(request_uri) c, request_uri
        FROM %(access_tab)s
        WHERE virtual_host="%(vhost)s"
            AND request_uri NOT LIKE "%%.png"
            AND request_uri NOT LIKE "%%.gif"
            AND request_uri NOT LIKE "%%.jpg"
            AND request_uri NOT LIKE "%%.css"
            AND request_uri NOT LIKE "/robots.txt"
            AND request_uri NOT LIKE "/favicon.ico"
        GROUP BY request_uri
        ORDER BY c DESC
        LIMIT %(limit)d""" % {
            'access_tab': config['access_tab'],
            'vhost': config['vhost'],
            'limit': lim,
            }

        if self._top_request is None or self._top_request_lim != lim:
            self._top_request_lim = lim
            self.cur.execute(q)
            self._top_request = self.cur.fetchall()

        return self._top_request

    def top_requestor(self, lim):
        q = """
        SELECT COUNT(remote_host) c, remote_host
        FROM %(access_tab)s
        WHERE virtual_host="%(vhost)s"
        GROUP BY remote_host
        ORDER BY c DESC
        LIMIT %(limit)d""" % {
            'access_tab': config['access_tab'],
            'vhost': config['vhost'],
            'limit': lim,
            }

        if self._top_requestor is None or self._top_requestor_lim != lim:
            self._top_requestor_lim = lim
            self.cur.execute(q)
            self._top_requestor = self.cur.fetchall()

        return self._top_requestor

    def top_error_request(self, lim):
        q = """
        SELECT COUNT(request_uri) c, request_uri
        FROM %(access_tab)s
        WHERE virtual_host="%(vhost)s"
            AND status >= 400
        GROUP BY request_uri
        ORDER BY c DESC
        LIMIT %(limit)d""" % {
            'access_tab': config['access_tab'],
            'vhost': config['vhost'],
            'limit': lim,
            }

        if self._top_error_request is None or self._top_error_request_lim != lim:
            self._top_error_request_lim = lim
            self.cur.execute(q)
            self._top_error_request = self.cur.fetchall()

        return self._top_error_request

    def top_error_requestor(self, lim):
        q = """
        SELECT COUNT(remote_host) c, remote_host
        FROM %(access_tab)s
        WHERE virtual_host="%(vhost)s"
            AND status >= 400
        GROUP BY remote_host
        ORDER BY c DESC
        LIMIT %(limit)d""" % {
            'access_tab': config['access_tab'],
            'vhost': config['vhost'],
            'limit': lim,
            }

        if self._top_error_requestor is None or self._top_error_requestor_lim != lim:
            self._top_error_requestor_lim = lim
            self.cur.execute(q)
            self._top_error_requestor = self.cur.fetchall()

        return self._top_error_requestor

    def bot_request(self, bot):
        q = """
        SELECT COUNT(agent)
        FROM %(access_tab)s
        WHERE virtual_host="%(vhost)s"
            AND agent LIKE "%%%(bot)s%%" """ % { 
                'access_tab': config['access_tab'],
                'vhost': config['vhost'],
                'bot': bot
                }

        if not self._bot.has_key(bot):
            self.cur.execute(q)
            self._bot[bot] = self.cur.fetchone()[0]

        return self._bot[bot]

    def status(self, status):
        q = """
        SELECT COUNT(status)
        FROM %(access_tab)s
        WHERE virtual_host="%(vhost)s"
            AND status = %(status)s" """ % {
            'access_tab': config['access_tab'],
            'vhost': config['vhost'],
            'status': status
            }

        if not self._status.has_key(status):
            self.cur.execute(q)
            self._status[status] = self.cur.fetchone()[0]

        return self._status[status]

if __name__ == '__main__':
    cursor = dbcursor()
    print top_referers(10)
#    print sql['top_referers'] % { 'access_tab': config['access_tab'],
#        'vhost': config['vhost'], 'limit': 10 }
