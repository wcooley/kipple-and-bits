<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName victoriassecretgarden.com
	ServerAlias *.victoriassecretgarden.com
	ServerAdmin webmaster@victoriassecretgarden.com
	DocumentRoot /home/httpd/virtual/victoriassecretgarden.com
	ErrorLog /var/log/httpd/victoriassecretgarden.com/error
	CustomLog /var/log/httpd/victoriassecretgarden.com/access combined
	ScriptLog /var/log/httpd/victoriassecretgarden.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/victoriassecretgarden.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	