<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName homegrowngreen.com
	ServerAlias *.homegrowngreen.com
	ServerAdmin webmaster@homegrowngreen.com
	DocumentRoot /home/httpd/virtual/homegrowngreen.com
	ErrorLog /var/log/httpd/homegrowngreen.com/error
	CustomLog /var/log/httpd/homegrowngreen.com/access combined
	ScriptLog /var/log/httpd/homegrowngreen.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/homegrowngreen.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	