<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName nwfleamart.com
	ServerAlias *.nwfleamart.com
	ServerAdmin webmaster@nwfleamart.com
	DocumentRoot /home/httpd/virtual/nwfleamart.com
	ErrorLog /var/log/httpd/nwfleamart.com/error
	CustomLog /var/log/httpd/nwfleamart.com/access combined
	ScriptLog /var/log/httpd/nwfleamart.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/nwfleamart.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/nwfleamart.com/
</Virtualhost>
	