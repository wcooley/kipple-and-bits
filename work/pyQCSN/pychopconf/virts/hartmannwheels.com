<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName hartmannwheels.com
	ServerAlias *.hartmannwheels.com
	ServerAdmin webmaster@hartmannwheels.com
	DocumentRoot /home/httpd/virtual/hartmannwheels.com
	ErrorLog /var/log/httpd/hartmannwheels.com/error
	CustomLog /var/log/httpd/hartmannwheels.com/access combined
	ScriptLog /var/log/httpd/hartmannwheels.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/hartmannwheels.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	