<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@enjoyfood.com
	DocumentRoot /home/httpd/virtual/enjoyfood.com
	ServerName enjoyfood.com
	ServerAlias *.enjoyfood.com
	ErrorLog /var/log/httpd/enjoyfood.com/error
	CustomLog /var/log/httpd/enjoyfood.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/enjoyfood.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	Alias /stats/ /home/httpd/stats/enjoyfood.com/
</Virtualhost>
	