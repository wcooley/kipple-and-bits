<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName caffertychiro.com
	ServerAlias *.caffertychiro.com
	ServerAdmin webmaster@caffertychiro.com
	DocumentRoot /home/httpd/virtual/caffertychiro.com
	ErrorLog /var/log/httpd/caffertychiro.com/error
	CustomLog /var/log/httpd/caffertychiro.com/access combined
	ScriptLog /var/log/httpd/caffertychiro.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/caffertychiro.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	