<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/hansnelson
	ServerName hansnelson-sons.com
	ServerAlias *.hansnelson-sons.com
	ErrorLog /var/log/httpd/hansnelson-sons.com/error
	CustomLog /var/log/httpd/hansnelson-sons.com/access combined
	AddType application/x-httpd-cgi .cgi
	ScriptAlias /cgi-bin/ /home/httpd/virtual/hansnelson/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	