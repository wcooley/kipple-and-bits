<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@siliconquill.com
	DocumentRoot /home/httpd/virtual/siliconquill.com
	ServerName siliconquill.com
	ServerAlias *.siliconquill.com
	ServerAlias siliconquill.com
	ErrorLog /var/log/httpd/siliconquill.com/error
	CustomLog /var/log/httpd/siliconquill.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/community-search.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	Alias /stats/ /home/httpd/stats/siliconquill.com/
	ErrorDocument 404 /oops.html
</Virtualhost>
	