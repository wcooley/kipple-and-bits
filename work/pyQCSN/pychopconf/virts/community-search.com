<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@community-search.com
	DocumentRoot /home/httpd/virtual/community-search.com
	ServerName community-search.com
	ServerAlias *.community-search.com
	ServerAlias *.community-search.com
	Options All Includes
	ErrorLog /var/log/httpd/community-search.com/error
	CustomLog /var/log/httpd/community-search.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/community-search.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	AddHandler cgi-script cgi
	#ErrorDocument 404 /oops.html
</Virtualhost>
	