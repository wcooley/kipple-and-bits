<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName lastvoice.com
	ServerAlias *.lastvoice.com
	ServerAdmin webmaster@lastvoice.com
	DocumentRoot /home/httpd/virtual/lastvoice.com
	ErrorLog /var/log/httpd/lastvoice.com/error
	CustomLog /var/log/httpd/lastvoice.com/access combined
	ScriptLog /var/log/httpd/lastvoice.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/lastvoice.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	