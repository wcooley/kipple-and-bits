<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName frhinternational.com
	ServerAlias *.frhinternational.com
	ServerAdmin webmaster@frhinternational.com
	DocumentRoot /home/httpd/virtual/frhinternational.com
	ErrorLog /var/log/httpd/frhinternational.com/error
	CustomLog /var/log/httpd/frhinternational.com/access combined
	ScriptLog /var/log/httpd/frhinternational.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/frhinternational.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/frhinternational.com/
</Virtualhost>
	