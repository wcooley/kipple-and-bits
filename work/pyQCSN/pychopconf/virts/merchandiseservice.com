<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName merchandiseservice.com
	ServerAlias *.merchandiseservice.com
	ServerAdmin webmaster@merchandiseservice.com
	DocumentRoot /home/httpd/virtual/merchandiseservice.com
	ErrorLog /var/log/httpd/merchandiseservice.com/error
	CustomLog /var/log/httpd/merchandiseservice.com/access combined
	ScriptLog /var/log/httpd/merchandiseservice.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/merchandiseservice.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	