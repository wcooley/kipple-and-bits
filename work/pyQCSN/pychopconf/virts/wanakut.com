<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName wanakut.com
	ServerAlias *.wanakut.com
	ServerAdmin webmaster@wanakut.com
	DocumentRoot /home/httpd/virtual/wanakut.com
	ErrorLog /var/log/httpd/wanakut.com/error
	CustomLog /var/log/httpd/wanakut.com/access combined
	ScriptLog /var/log/httpd/wanakut.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/wanakut.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/wanakut.com/
</Virtualhost>
	