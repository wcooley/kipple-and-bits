<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName bikepac.com
	ServerAlias *.bikepac.com
	ServerAdmin webmaster@bikepac.com
	DocumentRoot /home/httpd/virtual/bikepac.com
	ErrorLog /var/log/httpd/bikepac.com/error
	CustomLog /var/log/httpd/bikepac.com/access combined
	ScriptLog /var/log/httpd/bikepac.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/bikepac.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/bikepac.com/
</Virtualhost>
	