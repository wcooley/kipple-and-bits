<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName salishponds.com
	ServerAlias *.salishponds.com
	ServerAdmin webmaster@salishponds.com
	DocumentRoot /home/httpd/virtual/salishponds.com
	ErrorLog /var/log/httpd/salishponds.com/error
	CustomLog /var/log/httpd/salishponds.com/access combined
	ScriptLog /var/log/httpd/salishponds.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/salishponds.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/salishponds.com/
</Virtualhost>
	