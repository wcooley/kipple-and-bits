<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName dakotabooks.com
	ServerAlias *.dakotabooks.com
	ServerAdmin webmaster@dakotabooks.com
	DocumentRoot /home/httpd/virtual/dakotabooks.com
	ErrorLog /var/log/httpd/dakotabooks.com/error
	CustomLog /var/log/httpd/dakotabooks.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/dakotabooks.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</Virtualhost>
	