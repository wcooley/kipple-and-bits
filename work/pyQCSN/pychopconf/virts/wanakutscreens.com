<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName wanakutscreens.com
	ServerAlias *.wanakutscreens.com
	ServerAdmin webmaster@wanakutscreens.com
	DocumentRoot /home/httpd/virtual/wanakutscreens.com
	ErrorLog /var/log/httpd/wanakutscreens.com/error
	CustomLog /var/log/httpd/wanakutscreens.com/access combined
	ScriptLog /var/log/httpd/wanakutscreens.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/wanakutscreens.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/wanakutscreens.com/
</Virtualhost>
	