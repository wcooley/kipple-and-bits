<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/skitools.com
	ServerName skitools.com
	ServerAlias *.skitools.com
	ErrorLog /var/log/httpd/skitools.com/error
	CustomLog /var/log/httpd/skitools.com/access combined
	#AddType application/x-httpd-cgi .cgi
	#ScriptAlias /cgi-bin/ /home/httpd/virtual/DOMAIN.COM/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	Alias /stats/ /home/httpd/stats/skitools.com/
</VirtualHost>
	