<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName inthegorge.com
	ServerAlias *.inthegorge.com
	ServerAdmin webmaster@inthegorge.com
	DocumentRoot /home/httpd/virtual/inthegorge.com
	ErrorLog /var/log/httpd/inthegorge.com/error
	CustomLog /var/log/httpd/inthegorge.com/access combined
	ScriptLog /var/log/httpd/inthegorge.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/inthegorge.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/inthegorge.com/
</Virtualhost>
	