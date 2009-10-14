#!/usr/bin/env python
#
# sentmail-stat - Generate some statistics from the Horde IMP 4.3 imp_sentmail table
#
# Written by Wil Cooley <wcooley@nakedape.cc>
#


import MySQLdb
from pprint import pprint as pp

dbname=''
dbhost=''
dbuser=''
dbpass=''

query_total_msgs = """
    select count(*)
        from imp_sentmail
    ;
"""

query_counts_by_user = """
    select count(*) as count, sentmail_who as sender
        from imp_sentmail 
        group by sentmail_who 
        order by count(*)
    ;
"""

query_counts_by_user_and_msg = """
    select count(*) as count, sentmail_who as sender, sentmail_messageid as message_id
        from imp_sentmail 
        group by sentmail_who, sentmail_messageid 
        order by count(*)
    ;
"""

query_max_msgs_per_user = """
    select count(*)
        from imp_sentmail 
        group by sentmail_who 
        order by count(*) desc
        limit 1
    ;
"""

query_max_recips_per_user = """
    SELECT COUNT(*)
        FROM imp_sentmail 
        GROUP BY sentmail_who, sentmail_messageid
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ;
"""

query_msg_count_counts = """
    SELECT msg_count, COUNT(*) AS msg_count_count
        FROM (SELECT COUNT(*) AS msg_count
            FROM imp_sentmail
            GROUP BY sentmail_who) AS imp_sentmail
        GROUP BY msg_count
"""

query_recip_count_counts = """
    SELECT msg_count, COUNT(*) AS msg_count_count
        FROM (SELECT COUNT(*) AS msg_count
            FROM imp_sentmail
            GROUP BY sentmail_who, sentmail_messageid) AS imp_sentmail
        GROUP BY msg_count
"""

query_stat_recips = """
    SELECT STD(msg_count), AVG(msg_count),
        AVG(msg_count) + 4 * STD(msg_count), MAX(msg_count)
    FROM (SELECT COUNT(*) AS msg_count
        FROM imp_sentmail
            GROUP BY sentmail_who, sentmail_messageid) AS imp_sentmail;
"""

query_stat_msgs = """
    SELECT STD(msg_count), AVG(msg_count),
        AVG(msg_count) + 4 * STD(msg_count), MAX(msg_count)
    FROM (SELECT COUNT(*) AS msg_count
        FROM imp_sentmail
            GROUP BY sentmail_who) AS imp_sentmail;
"""


row_fmt = '|%-16s|%8s|'
title_fmt = '|%-25s|'

def rpt_total_entries(curs):

    curs.execute(query_total_msgs)
    print row_fmt % ( 'Total entries:', curs.fetchone()[0] )

def print_stat(title, stat_tuple):
    (stddev, avg, z4, max) = stat_tuple

    print
    print title_fmt % title

    print row_fmt % ('Maximum', max)
    print row_fmt % ('Average', avg)
    print row_fmt % ('Stddev', stddev)
    print row_fmt % ('4 sigma', z4)


def rpt_stat_msgs(curs):

    curs.execute(query_stat_msgs)
    print_stat( 'Messages sent per user', curs.fetchone() )


def rpt_stat_recips(curs):

    curs.execute(query_stat_recips)
    print_stat( 'Recipients per message', curs.fetchone() )

def csv_msg_count_counts(curs):

    curs.execute(query_msg_count_counts)
    for row in curs.fetchall(): print "%s,%s" % row

def csv_recip_count_counts(curs):

    curs.execute(query_recip_count_counts)
    for row in curs.fetchall(): print "%s,%s" % row 

def csv_msg_counts_by_user(curs):

    curs.execute(query_counts_by_user)
    for row in curs.fetchall(): print "%s,%s" % row 

def csv_msg_counts_by_msg(curs):

    curs.execute(query_counts_by_user_and_msg)
    for row in curs.fetchall(): print "%s,%s,%s" % row


if __name__ == '__main__':

    db = MySQLdb.connect(passwd=dbpass, db=dbname, 
                host=dbhost, user=dbuser)

    curs = db.cursor()

    rpt_total_entries(curs)
    rpt_stat_msgs(curs)
    rpt_stat_recips(curs)

# You can use these to dump CSV data, which is handy for importing into a
# spreadsheet to make graphs

#    csv_msg_count_counts(curs)
#    csv_recip_count_counts(curs)
#    csv_msg_counts_by_user(curs)
#    csv_msg_counts_by_msg(curs)



