<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/adventurecruises.com
	ServerName adventurecruises.com
	ServerAlias *.adventurecruises.com
	ErrorLog /var/log/httpd/adventurecruises.com/error
	CustomLog /var/log/httpd/adventurecruises.com/access combined
	Alias /stats/ /home/httpd/stats/adventurecruises.com/
	ScriptAlias /cgi-bin/ /home/httpd/virtual/adventurecruises.com/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	