<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName handymanremodeling.com
	ServerAlias *.handymanremodeling.com
	ServerAdmin webmaster@handymanremodeling.com
	DocumentRoot /home/httpd/virtual/handymanremodeling.com
	ErrorLog /var/log/httpd/handymanremodeling.com/error
	CustomLog /var/log/httpd/handymanremodeling.com/access combined
	ScriptLog /var/log/httpd/handymanremodeling.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/handymanremodeling.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/handymanremodeling.com/
</Virtualhost>
	