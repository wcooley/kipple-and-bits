<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName hempinformation.com
	ServerAlias *.hempinformation.com
	ServerAdmin webmaster@hempinformation.com
	DocumentRoot /home/httpd/virtual/hempinformation.com
	ErrorLog /var/log/httpd/hempinformation.com/error
	CustomLog /var/log/httpd/hempinformation.com/access combined
	ScriptLog /var/log/httpd/hempinformation.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/hempinformation.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	