<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName wanakutltd.com
	ServerAlias *.wanakutltd.com
	ServerAdmin webmaster@wanakutltd.com
	DocumentRoot /home/httpd/virtual/wanakutltd.com
	ErrorLog /var/log/httpd/wanakutltd.com/error
	CustomLog /var/log/httpd/wanakutltd.com/access combined
	ScriptLog /var/log/httpd/wanakutltd.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/wanakutltd.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/wanakutltd.com/
</Virtualhost>
	