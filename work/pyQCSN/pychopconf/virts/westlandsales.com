<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/westlandsales.com
	ServerName westlandsales.com
	ServerAlias *.westlandsales.com
	ErrorLog /var/log/httpd/westlandsales.com/error
	CustomLog /var/log/httpd/westlandsales.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/westlandsales.com/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	