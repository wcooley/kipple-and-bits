#!/usr/bin/env python

import grp, pwd, os

VIRTDIR 	=	r'/home/httpd/virtual/'
#VIRTDIR 	=	r'/home/wcooley/work/pyQCSN/test/'
HTTPD_CONF_DIR = '/etc/httpd/conf/'
DNS_CONF	=	r'/var/named/virtuals.conf'
CONTACT_DB	=	r'/var/lib/contacts'
CMD_APACHE_RELOAD = r'/sbin/service httpd reload'
CMD_BIND_RECONF = r'/sbin/service named reconfig'

grwebadmin = grp.getgrnam("webadmin")[2]
pwwebadmin = pwd.getpwnam("webadmin")[2]

grstat = grp.getgrnam("nobody")[2]
pwstat = pwd.getpwnam("nobody")[2]

skel_dir = { 
	'cgi-bin': { 'mode': 0775, 'owner': '*owner*', 'group': grwebadmin},
	'conf': { 'mode': 0755, 'owner': pwwebadmin, 'group': grwebadmin},
	'docs': { 'mode': 0775, 'owner': '*owner*', 'group': grwebadmin},
	'logs': { 'mode': 0775, 'owner': pwwebadmin, 'group': grwebadmin},
	'stats': { 'mode': 0755, 'owner': pwwebadmin, 'group': grwebadmin}
}


errmsg = {
	'zone_exists' : "Error: zone %s already exists in %s!\nYou'll have to mangle things by hand.",
	'apache_cfg_exists' : "Error: Apache configuration for %s already exists!\nYou'll have to mangle this by hand.",
	'system_err' : "Error calling external program $(prog)s.  Output was:\n%(output)s",
}

ANALOG_CFG = """
DEBUG OFF
HOSTNAME "%(domain)s Web Statistics"
HOSTURL http://www.%(domain)s
OUTFILE /home/httpd/virtual/%(domain)s/stats/index.html
CONFIGFILE /home/httpd/etc/analog/global-bulk.cfg
VHOSTINCLUDE *%(domain)s
"""

APACHE_CFG = """
<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName %(domain)s
        ServerAlias *.%(domain)s
        ServerAdmin webmaster@%(domain)s
        DocumentRoot %(virtdir)s/docs/
        ErrorLog  /home/httpd/logs/error
        ScriptLog /home/httpd/logs/script
        CustomLog /home/httpd/logs/virtual vcommon
        ScriptAlias /cgi-bin/ %(virtdir)s/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ %(virtdir)s/stats/
        <IfModule mod_bandwidth.c>
                BandWidthModule on
                BandWidth all %(bandwidth)
                MinBandwidth all 8192
				BandWidthPulse 1000000
        </IfModule>
</Virtualhost>
"""

DUMMY_STAT = """
<html>
<head><title>Temporary Stats Page</title></head>
<body>
<h1>Temporary Stats Page</h1>
<p>This page is a placeholder for your site statistics page.
It will be replaced by a page with more meaningful information
after the hourly log analysis program is run.  If it has been more
than a few hours and this page is still here, place contact <a
href="mailto:support@qcsn.com">support@qcsn.com</a>.</p>
</body>
</html>
"""

DUMMY_PAGE = """
<html>
<head> <title>Not here yet</title> </head>
<body bgcolor="white">
<center>
<img src="http://www.community-search.com/images/com.gif" 
alt="A Community Search Production">
<h1>
This site is not here yet, but will be soon.  
<br>Please keep checking.</h1>
</center>
</body>
</html>
"""

NAMED_CONF = """
zone "%(domain)s" { type master; file "master/virtual"; } ;
"""

CONTACT_DB_ENTRY = """
Domain: %(domain)s added %(date)s
	Contact: %(contact)s
	Username: %(owner)s

"""

if __name__ == '__main__':
	print "This is a configuration file.  You don't really want to run it."
