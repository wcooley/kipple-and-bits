<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName safeworker.com
	ServerAlias *.safeworker.com
	ServerAlias safeworker.com
	ServerAdmin webmaster@safeworker.com
	DocumentRoot /home/httpd/virtual/safeworker.com
	ErrorLog /var/log/httpd/safeworker.com/error
	CustomLog /var/log/httpd/safeworker.com/access combined
	ScriptLog /var/log/httpd/safeworker.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/safeworker.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	