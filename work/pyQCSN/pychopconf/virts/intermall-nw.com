<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@intermall-nw.com
	DocumentRoot /home/httpd/virtual/intermall
	ServerName intermall-nw.com
	ServerAlias *.intermall-nw.com
	ErrorLog /var/log/httpd/intermall-nw.com/error
	CustomLog /var/log/httpd/intermall-nw.com/access combined
	AddType application/x-httpd-cgi .cgi
	ScriptAlias /cgi-bin/ /home/httpd/virtual/intermall/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	