<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/sandyins/
	ServerName sandyins.com
	ServerAlias *.sandyins.com
	ErrorLog /var/log/httpd/sandyins.com/error
	CustomLog /var/log/httpd/sandyins.com/access combined
	AddType application/x-httpd-cgi .cgi
	ScriptAlias /cgi-bin/ /home/httpd/virtual/sandyins/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	Alias /stats/ /home/httpd/stats/sandyins.com/
</VirtualHost>
	