<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName folckusa.com
	ServerAlias *.folckusa.com
	ServerAdmin webmaster@folckusa.com
	DocumentRoot /home/httpd/virtual/folckusa.com
	ErrorLog /var/log/httpd/folckusa.com/error
	CustomLog /var/log/httpd/folckusa.com/access combined
	ScriptLog /var/log/httpd/folckusa.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/folckusa.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/folckusa.com/
</Virtualhost>
	