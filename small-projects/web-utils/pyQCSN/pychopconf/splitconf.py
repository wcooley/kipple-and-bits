#!/usr/bin/python

import os, re

matchre = re.compile( r"""(?P<vhost>
	<VirtualHost.*?
		ServerName\s*(?P<servername>[^\s]*)
	.*?</VirtualHost>\n)
	""", re.IGNORECASE|re.DOTALL|re.VERBOSE)

#conf = open("mv.conf", "r").read()
conf = open("virtuals.conf", "r").read()

matches = matchre.findall(conf)

for entry in matches:
	vhost = entry[0]
	servername = entry[1]

	# Add the new IP for Fleetwood
	vhost = re.sub("198.145.93.8", "198.145.93.8 65.201.55.8", vhost, 1)

	# Make the domain the servername if it started with www. and add *.domain serveralias
	vhost = re.sub("(?mi)ServerName\s*www\.(?P<domain>.*)$", "ServerName \g<domain>\nServerAlias *.\g<domain>", vhost, 1)

	# Indent those not already indented
	vhost = re.sub("(?m)^(?!</?Vir|\s)", "\t\g<0>", vhost)
	
	# Change the MinBandWidth line
	vhost = re.sub("(?m)^(\s*)MinBandwidth all.*$", "\g<1>MinBandwidth all 8192", vhost)

	# Change the name of output filename
	servername = re.sub("www\.(?P<domain>)", "\g<domain>", servername)

	outfile = os.path.join("virts", servername)

	#print vhost
	if (os.access(outfile, os.F_OK)):
		print "Error: ", servername, " already exists!"
		outfile = outfile + ".1"
	open(outfile, "w").write(vhost)
	print "Processing: ", servername
