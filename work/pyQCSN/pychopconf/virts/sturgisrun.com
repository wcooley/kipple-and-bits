<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName sturgisrun.com
	ServerAlias *.sturgisrun.com
	ServerAdmin webmaster@sturgisrun.com
	DocumentRoot /home/httpd/virtual/sturgisrun.com
	ErrorLog /var/log/httpd/sturgisrun.com/error
	CustomLog /var/log/httpd/sturgisrun.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/sturgisrun.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</Virtualhost>
	