<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName ah8dx.com
	ServerAlias *.ah8dx.com
	ServerAdmin webmaster@ah8dx.com
	DocumentRoot /home/httpd/virtual/ah8dx.com
	ErrorLog /var/log/httpd/ah8dx.com/error
	CustomLog /var/log/httpd/ah8dx.com/access combined
	ScriptLog /var/log/httpd/ah8dx.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/ah8dx.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/ah8dx.com/
</Virtualhost>
	