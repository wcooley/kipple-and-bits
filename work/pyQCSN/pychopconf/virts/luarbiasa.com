<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName luarbiasa.com
	ServerAlias *.luarbiasa.com
	ServerAlias luarbiasa.com
	ServerAdmin webmaster@luarbiasa.com
	DocumentRoot /home/httpd/virtual/luarbiasa.com
	ErrorLog /var/log/httpd/luarbiasa.com/error
	CustomLog /var/log/httpd/luarbiasa.com/access combined
	ScriptLog /var/log/httpd/luarbiasa.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/luarbiasa.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	