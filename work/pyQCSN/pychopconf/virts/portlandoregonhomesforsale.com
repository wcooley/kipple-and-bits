<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName portlandoregonhomesforsale.com
	ServerAlias *.portlandoregonhomesforsale.com
	ServerAdmin webmaster@portlandoregonhomesforsale.com
	DocumentRoot /home/httpd/virtual/portlandoregonhomesforsale.com
	ErrorLog /var/log/httpd/portlandoregonhomesforsale.com/error
	CustomLog /var/log/httpd/portlandoregonhomesforsale.com/access combined
	ScriptLog /var/log/httpd/portlandoregonhomesforsale.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/portlandoregonhomesforsale.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/portlandoregonhomesforsale.com/
</Virtualhost>
	