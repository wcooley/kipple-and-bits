<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName yourdinnerisserved.com
	ServerAlias *.yourdinnerisserved.com
	ServerAdmin webmaster@yourdinnerisserved.com
	DocumentRoot /home/httpd/virtual/yourdinnerisserved.com
	ErrorLog /var/log/httpd/yourdinnerisserved.com/error
	CustomLog /var/log/httpd/yourdinnerisserved.com/access combined
	ScriptLog /var/log/httpd/yourdinnerisserved.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/yourdinnerisserved.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/yourdinnerisserved.com/
</Virtualhost>
	