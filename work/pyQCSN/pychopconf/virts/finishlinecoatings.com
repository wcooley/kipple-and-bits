<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName finishlinecoatings.com
	ServerAlias *.finishlinecoatings.com
	ServerAdmin webmaster@finishlinecoatings.com
	DocumentRoot /home/httpd/virtual/finishlinecoatings.com
	ErrorLog /var/log/httpd/finishlinecoatings.com/error
	CustomLog /var/log/httpd/finishlinecoatings.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/finishlinecoatings.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</Virtualhost>
	