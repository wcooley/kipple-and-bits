<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName splendide.com
	ServerAlias *.splendide.com
	ServerAdmin webmaster@splendide.com
	DocumentRoot /home/httpd/virtual/splendide.com
	ErrorLog /var/log/httpd/splendide.com/error
	CustomLog /var/log/httpd/splendide.com/access combined
	ScriptLog /var/log/httpd/splendide.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/splendide.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	