<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName eauvent.com
	ServerAlias *.eauvent.com
	ServerAdmin webmaster@eauvent.com
	DocumentRoot /home/httpd/virtual/eauvent.com
	ErrorLog /var/log/httpd/eauvent.com/error
	CustomLog /var/log/httpd/eauvent.com/access combined
	ScriptLog /var/log/httpd/eauvent.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/eauvent.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/eauvent.com/
</Virtualhost>
	