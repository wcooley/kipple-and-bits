<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName artistswayclasses.com
	ServerAlias *.artistswayclasses.com
	ServerAdmin webmaster@artistswayclasses.com
	DocumentRoot /home/httpd/virtual/artistswayclasses.com
	ErrorLog /var/log/httpd/artistswayclasses.com/error
	CustomLog /var/log/httpd/artistswayclasses.com/access combined
	ScriptLog /var/log/httpd/artistswayclasses.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/artistswayclasses.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	