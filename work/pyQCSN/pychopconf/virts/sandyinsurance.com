<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName sandyinsurance.com
	ServerAlias *.sandyinsurance.com
	ServerAdmin webmaster@sandyinsurance.com
	DocumentRoot /home/httpd/virtual/sandyinsurance.com
	ErrorLog /var/log/httpd/sandyinsurance.com/error
	CustomLog /var/log/httpd/sandyinsurance.com/access combined
	ScriptLog /var/log/httpd/sandyinsurance.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/sandyinsurance.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/sandyinsurance.com/
</Virtualhost>
	