<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/simple-search.com
	ServerName simple-search.com
	ServerAlias *.simple-search.com
	ErrorLog /var/log/httpd/simple-search.com/error
	CustomLog /var/log/httpd/simple-search.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/simple-search.com/cgi-bin/
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	