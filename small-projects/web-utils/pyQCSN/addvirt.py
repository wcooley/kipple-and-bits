#!/usr/bin/env python

from snack import *
import os, sys

# Make sure the module path is set correctly

sys.path.append("/usr/local/lib/python")

#from pyaddvirt.menu import *
#from pyaddvirt.vhost import *
#from pyaddvirt.conf import *
#from pyaddvirt.util import *

from pyaddvirt import *

cmd_output = ""

if __name__ == '__main__':
	vhostinfo = get_vhost_info()

	if len(vhostinfo) == 0:
		print "User cancelled"

	else:
		register_domain(vhostinfo['domain'], vhostinfo['username'], vhostinfo['realname'])
		make_vhost_skel (vhostinfo['domain'], vhostinfo['username'])
		conf_analog(vhostinfo['domain'])
		conf_master_dns(vhostinfo['domain'])
		reload_dns()
		if not vhostinfo['bulkhost']:
			conf_apache(vhostinfo['domain'])
			reload_apache()	
		show_ouput(cmd_output)
		show_reminder()
		print "Domain: %s" % vhostinfo['domain']
		print "Username: %s" % vhostinfo['username']
		print "Real name: %s" % vhostinfo['realname']
		print "Disk Quota: %s MB" % vhostinfo['diskquota']
		print "Bandwidth Quota: %s kbps" % vhostinfo['bandwidthquota']

