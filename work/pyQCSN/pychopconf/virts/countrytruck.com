<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/countrytruck.com
	ServerName countrytruck.com
	ServerAlias *.countrytruck.com
	ErrorLog /var/log/httpd/countrytruck.com/error
	CustomLog /var/log/httpd/countrytruck.com/access combined
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	Alias /stats/ /home/httpd/stats/countrytruck.com/
</VirtualHost>
	