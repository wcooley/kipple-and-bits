<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/fowlks/
	ServerName fowlks-snyder.com
	ServerAlias *.fowlks-snyder.com
	ErrorLog /var/log/httpd/fowlks-snyder.com/error
	CustomLog /var/log/httpd/fowlks-snyder.com/access combined
	AddType application/x-httpd-cgi .cgi
	ScriptAlias /cgi-bin/ /home/httpd/virtual/fowlks/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	