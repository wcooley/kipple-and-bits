<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/thriftyautosupply.com/
	ServerName thriftyautosupply.com
	ServerAlias *.thriftyautosupply.com
	ErrorLog /var/log/httpd/thriftyautosupply.com/error
	CustomLog /var/log/httpd/thriftyautosupply.com/access combined
	AddType application/x-httpd-cgi .cgi
	ScriptAlias /cgi-bin/ /home/httpd/virtual/thrifty/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	