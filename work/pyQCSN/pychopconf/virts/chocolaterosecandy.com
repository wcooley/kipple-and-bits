<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName chocolaterosecandy.com
	ServerAlias *.chocolaterosecandy.com
	ServerAdmin webmaster@chocolaterosecandy.com
	DocumentRoot /home/httpd/virtual/chocolaterosecandy.com
	ErrorLog /var/log/httpd/chocolaterosecandy.com/error
	CustomLog /var/log/httpd/chocolaterosecandy.com/access combined
	ScriptLog /var/log/httpd/chocolaterosecandy.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/chocolaterosecandy.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	