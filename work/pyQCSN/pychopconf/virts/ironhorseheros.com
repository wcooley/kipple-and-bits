<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName ironhorseheros.com
	ServerAlias *.ironhorseheros.com
	ServerAdmin webmaster@ironhorseheros.com
	DocumentRoot /home/httpd/virtual/ironhorseheros.com
	ErrorLog /var/log/httpd/ironhorseheros.com/error
	CustomLog /var/log/httpd/ironhorseheros.com/access combined
	ScriptLog /var/log/httpd/ironhorseheros.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/ironhorseheros.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	