<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName armstrongtaxidermy.com
	ServerAlias *.armstrongtaxidermy.com
	ServerAdmin webmaster@armstrongtaxidermy.com
	DocumentRoot /home/httpd/virtual/armstrongtaxidermy.com
	ErrorLog /var/log/httpd/armstrongtaxidermy.com/error
	CustomLog /var/log/httpd/armstrongtaxidermy.com/access combined
	ScriptLog /var/log/httpd/armstrongtaxidermy.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/armstrongtaxidermy.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/armstrongtaxidermy.com/
</Virtualhost>
	