<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName hempshirts.com
	ServerAlias *.hempshirts.com
	ServerAdmin webmaster@hempshirts.com
	DocumentRoot /home/httpd/virtual/hempshirts.com
	ErrorLog /var/log/httpd/hempshirts.com/error
	CustomLog /var/log/httpd/hempshirts.com/access combined
	ScriptLog /var/log/httpd/hempshirts.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/hempshirts.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	