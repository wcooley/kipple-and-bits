<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName onlinehempfest.com
	ServerAlias *.onlinehempfest.com
	ServerAdmin webmaster@onlinehempfest.com
	DocumentRoot /home/httpd/virtual/onlinehempfest.com
	ErrorLog /var/log/httpd/onlinehempfest.com/error
	CustomLog /var/log/httpd/onlinehempfest.com/access combined
	ScriptLog /var/log/httpd/onlinehempfest.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/onlinehempfest.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	