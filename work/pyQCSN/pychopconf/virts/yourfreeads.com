<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@yourfreeads.com
	DocumentRoot /home/httpd/virtual/yourfreeads.com
	ServerName yourfreeads.com
	ServerAlias *.yourfreeads.com
	ServerAlias yourfreeads.com
	ErrorLog /var/log/httpd/yourfreeads.com/error
	CustomLog /var/log/httpd/yourfreeads.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/community-search.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</Virtualhost>
	