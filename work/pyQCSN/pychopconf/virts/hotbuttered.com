<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@hotbuttered.com
	DocumentRoot /home/httpd/virtual/hotbuttered.com
	ServerName hotbuttered.com
	ServerAlias *.hotbuttered.com
	ServerAlias hotbuttered.com
	ErrorLog /var/log/httpd/hotbuttered.com/error
	CustomLog /var/log/httpd/hotbuttered.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/community-search.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	ErrorDocument 404 /oops.html
</Virtualhost>
	