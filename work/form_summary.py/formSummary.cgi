#!/usr/bin/python

import cgi, sys

print "Content-Type: text/html\n\n"
print "<html><head><title>Form Summary</title></head><body bgcolor=\"white\">"

sys.stderr = sys.stdout

form = cgi.FieldStorage()

print "Form inputs:<br>"
for key in form.keys():
	print "%s<br>" % key

#content = cgi.parse_header()

print "Content:<br>"
for key in content.keys():
	print "%s<br>" % key

print "</body></html>"
