<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName nwonlinefleamarket.com
	ServerAlias *.nwonlinefleamarket.com
	ServerAdmin webmaster@nwonlinefleamarket.com
	DocumentRoot /home/httpd/virtual/nwonlinefleamarket.com
	ErrorLog /var/log/httpd/nwonlinefleamarket.com/error
	CustomLog /var/log/httpd/nwonlinefleamarket.com/access combined
	ScriptLog /var/log/httpd/nwonlinefleamarket.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/nwonlinefleamarket.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/nwonlinefleamarket.com/
</Virtualhost>
	