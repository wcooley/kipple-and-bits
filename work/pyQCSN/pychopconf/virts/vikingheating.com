<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/vikingheating.com
	ServerName vikingheating.com
	ServerAlias *.vikingheating.com
	ErrorLog /var/log/httpd/vikingheating.com/error
	CustomLog /var/log/httpd/vikingheating.com/access combined
	#AddType application/x-httpd-cgi .cgi
	#ScriptAlias /cgi-bin/ /home/httpd/virtual/DOMAIN.COM/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	