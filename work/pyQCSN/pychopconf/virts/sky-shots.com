<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/sky-shots.com
	ServerName sky-shots.com
	ServerAlias *.sky-shots.com
	ErrorLog /var/log/httpd/sky-shots.com/error
	CustomLog /var/log/httpd/sky-shots.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/sky-shots.com/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	