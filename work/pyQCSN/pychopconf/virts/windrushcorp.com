<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName windrushcorp.com
	ServerAlias *.windrushcorp.com
	ServerAlias windrushcorp.com
	ServerAdmin webmaster@windrushcorp.com
	DocumentRoot /home/httpd/virtual/windrushcorp.com
	ErrorLog /var/log/httpd/windrushcorp.com/error
	CustomLog /var/log/httpd/windrushcorp.com/access combined
	ScriptLog /var/log/httpd/windrushcorp.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/windrushcorp.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	