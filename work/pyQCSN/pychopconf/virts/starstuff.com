<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@starstuff.com
	DocumentRoot /home/httpd/virtual/starstuff.com
	ServerName starstuff.com
	ServerAlias *.starstuff.com
	ErrorLog /var/log/httpd/starstuff.com/error
	CustomLog /var/log/httpd/starstuff.com/access combined
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	