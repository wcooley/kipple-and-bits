<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName ceilingsystems-nw.com
	ServerAlias *.ceilingsystems-nw.com
	ServerAdmin webmaster@ceilingsystems-nw.com
	DocumentRoot /home/httpd/virtual/ceilingsystems-nw.com
	ErrorLog /var/log/httpd/ceilingsystems-nw.com/error
	CustomLog /var/log/httpd/ceilingsystems-nw.com/access combined
	ScriptLog /var/log/httpd/ceilingsystems-nw.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/ceilingsystems-nw.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/ceilingsystems-nw.com/
</Virtualhost>
	