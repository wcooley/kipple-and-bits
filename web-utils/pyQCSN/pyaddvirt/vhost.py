#!/usr/bin/python

from conf import *
from util import *
from menu import *
import pwd,grp,re,sys,os,string

cmd_output = ""

def make_vhost_skel (domain, owner = 'carol', group = 'webadmin'):
	"""Makes a skeleton directory and placeholder files for a new vhost"""	
	global cmd_output

	# Look up the username & group name
	ownerid = pwd.getpwnam(owner)[2]
	groupid = grp.getgrnam(group)[2]

	virtdir = os.path.join(VIRTDIR, domain)
	os.mkdir (virtdir)

	# Create the vhost's subdirs and set ownership & perms
	for subdir in (skel_dir.keys()):
		key = subdir
		subdir = os.path.join(virtdir,subdir)
		os.makedirs(subdir)

		if skel_dir[key]['owner'] == '*owner*':
			skel_dir[key]['owner'] = ownerid

		if skel_dir[key]['group'] == '*group*':
			skel_dir[key]['group'] = groupid

		os.chown(subdir, skel_dir[key]['owner'], skel_dir[key]['group'])	

		# Have to set it here, because the chown above
		# sometimes clears world and group bits
		os.chmod(subdir, skel_dir[key]['mode'])

		cmd_output = cmd_output + "Created directory skeleton for user %s, group %s\n" % (owner, group)

	dummypage = os.path.join(virtdir, "docs", "index.html")
	open(dummypage, "w").write(DUMMY_PAGE)
	os.chown (dummypage, ownerid, grwebadmin)

	dummystat = os.path.join(virtdir, "stats", "index.html")
	open(dummystat, "w").write(DUMMY_STAT)
	os.chown (dummystat, pwstat, grstat)

	cmd_output = cmd_output + "Wrote dummy index and stats pages.\n"
	

def conf_analog (domain):
	"""Writes a configuration for Analog"""
	global cmd_output

	analog_cfg = os.path.join(VIRTDIR, domain, "conf", "analog.cfg")
	open(analog_cfg, "w").write(ANALOG_CFG % vars())

	os.chown (analog_cfg, pwwebadmin, grwebadmin)

	cmd_output = cmd_output + "Wrote Analog configuration.\n"

def conf_apache(domain):
	"""Writes a configuration for Apache"""
	global cmd_output

	virtdir = os.path.join(VIRTDIR, domain)
	apache_cfg = os.path.join(HTTPD_CONF_DIR, 'virts', domain)

	if os.access(apache_cfg, os.F_OK):
		show_error_box(errmsg['apache_cfg_exists'])

	open(apache_cfg, "w").write(APACHE_CFG % vars())

	cmd_output = cmd_ouput + "Wrote Apache configuration.\n"

	
def conf_master_dns(domain):
	"""Writes an entry to the master BIND configuration file for a generic domain"""

	global cmd_output
	output = ""
	dns_conf = open(DNS_CONF)

	for line in dns_conf.readlines():
		if string.find(line, 'zone "%s"' % domain ) != -1:
			show_error_box(errmsg['zone_exists'] % (domain, DNS_CONF))
			sys.exit(1)

	dns_conf.close()
	
	# Check out the config file
	prog = "co -l %s" % DNS_CONF
	output = output + prog + "\n"
	out = os.popen(prog, "r")
	output = output + out.read()
	if not convert_return(out.close()):
		show_error_box(errmsg['system_err'] % (prog,output))
		sys.exit(1)

	# Edit the config file
	open(DNS_CONF, "a").write(NAMED_CONF % vars())

	# Check it back in
	prog = 'ci -u -m"Added %s" %s' % (domain,DNS_CONF)
	output = output + "Running %s\n" % prog
	out = os.popen(prog, 'r')
	output = output + out.read()
	if not convert_return(out.close()):
		show_error_box(errmsg['system_err'] % (prog,output))
		sys.exit(1)

	cmd_output = cmd_output + output

def register_domain(domain, owner, contact):
	"""Writes an entry to the contacts database, to keep track of users owning domains"""
	global cmd_output

	date = nice_date()
	print "CONTACT_DB: %s" % CONTACT_DB
	print type(CONTACT_DB)
	contact_db = open(CONTACT_DB, 'a').write(CONTACT_DB_ENTRY % vars())

	#cmd_output = cmd_output + "Wrote contact entry.\n"
	cmd_output = cmd_output + "Wrote contact entry.\n"
	
def reload_apache():
	""" Command to reload Apache """
	global cmd_output

	output = "Running %s\n" % CMD_APACHE_RELOAD

	out = os.popen(CMD_APACHE_RELOAD, 'r')
	output = output + out.read()

	cmd_output = cmd_output + output

	ret = out.close()

	return convert_return(ret)
		

def reload_dns():
	""" Command to tell BIND to look for new zones"""
	global cmd_output

	output = "Running %s\n" % CMD_BIND_RECONF
	out = os.popen(CMD_BIND_RECONF, 'r')
	output = output + out.read()
	ret = out.close()
	
	return convert_return(ret)

if __name__ == '__main__':
	#print "This is a library module.  You probably don't need to run it."	
	print cmd_output
	register_domain("example.com", "wcooley", "Wil")
	print cmd_output

