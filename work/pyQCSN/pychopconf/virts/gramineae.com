<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/gramineae.com/
	ServerName gramineae.com
	ServerAlias *.gramineae.com
	ErrorLog /var/log/httpd/gramineae.com/error
	CustomLog /var/log/httpd/gramineae.com/access combined
	AddType application/x-httpd-cgi .cgi
	ScriptAlias /cgi-bin/ /home/httpd/virtual/gram/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	