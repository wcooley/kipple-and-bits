<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName columbiarivercruises.com
	ServerAlias *.columbiarivercruises.com
	ServerAdmin webmaster@columbiarivercruises.com
	DocumentRoot /home/httpd/virtual/columbiarivercruises.com
	ErrorLog /var/log/httpd/columbiarivercruises.com/error
	CustomLog /var/log/httpd/columbiarivercruises.com/access combined
	ScriptLog /var/log/httpd/columbiarivercruises.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/columbiarivercruises.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	