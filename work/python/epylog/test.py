#!/usr/bin/python2

import sys, re

rc = re.compile

test = """amavis[5691]: (05691-06) TIMING [total 3257 ms] - SMTP EHLO: 3 (0%), SMTP pre-MAIL: 1 (0%), SMTP pre-DATA-flush: 4 (0%), SMTP DATA: 80 (2%), body hash: 1 (0%), mime_decode: 20 (1%), get-file-type: 30 (1%), decompose_part: 10 (0%), parts: 0 (0%), AV-scan-1: 12 (0%), SA msg read: 4 (0%), SA parse: 2 (0%), SA check: 2844 (87%), fwd-connect: 10 (0%), fwd-mail-from: 2 (0%), fwd-rcpt-to: 1 (0%), write-header: 18 (1%), fwd-data: 9 (0%), fwd-data-end: 197 (6%), fwd-rundown: 2 (0%), unlink-1-files: 5 (0%), rundown: 0 (0%)"""

test2 = """amavis[5691]: (05691-06) FWD via SMTP: [127.0.0.1:10025] <root@mail.northwesthomecare.com> -> <wcooley@nakedape.cc>"""

#test_re = rc(r'^.*total (\d+) .*$')
#m = test_re.search(test)
#print "Time: %s" % m.group(1)

#test2_re = rc(r'-> \<(.*)\>')

email_parts_re = rc(r'-> \<([^@]+)@([^@]+)\>')


#m = test2_re.search(test2)
#print "Found e-mail recipient: %s" % m.group(1)
m2 = email_parts_re.search(test2)


if m2 is not None:
    print "Address parts: %s '@' %s" % (m2.group(1), m2.group(2))
else:
    print "Couldn't decompose e-mail address"
