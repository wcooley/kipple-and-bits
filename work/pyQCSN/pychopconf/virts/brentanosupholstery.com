<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName brentanosupholstery.com
	ServerAlias *.brentanosupholstery.com
	ServerAdmin webmaster@brentanosupholstery.com
	DocumentRoot /home/httpd/virtual/brentanosupholstery.com
	ErrorLog /var/log/httpd/brentanosupholstery.com/error
	CustomLog /var/log/httpd/brentanosupholstery.com/access combined
	ScriptLog /var/log/httpd/brentanosupholstery.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/brentanosupholstery.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/brentanosupholstery.com/
</Virtualhost>
	