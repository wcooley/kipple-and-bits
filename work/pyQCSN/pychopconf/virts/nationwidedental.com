<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName nationwidedental.com
	ServerAlias *.nationwidedental.com
	ServerAdmin webmaster@nationwidedental.com
	DocumentRoot /home/httpd/virtual/nationwidedental.com
	ErrorLog /var/log/httpd/nationwidedental.com/error
	CustomLog /var/log/httpd/nationwidedental.com/access combined
	ScriptLog /var/log/httpd/nationwidedental.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/nationwidedental.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	