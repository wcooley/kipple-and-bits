<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName realdowntown.com
	ServerAlias *.realdowntown.com
	ServerAdmin webmaster@realdowntown.com
	DocumentRoot /home/httpd/virtual/realdowntown.com
	ErrorLog /var/log/httpd/realdowntown.com/error
	CustomLog /var/log/httpd/realdowntown.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/realdowntown.com/cgi-bin
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</Virtualhost>
	