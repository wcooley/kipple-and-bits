<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName truth-beacon.com
	ServerAlias *.truth-beacon.com
	ServerAdmin webmaster@truth-beacon.com
	DocumentRoot /home/httpd/virtual/truth-beacon.com
	ErrorLog /var/log/httpd/truth-beacon.com/error
	CustomLog /var/log/httpd/truth-beacon.com/access combined
	ScriptLog /var/log/httpd/truth-beacon.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/truth-beacon.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/truth-beacon.com/
</Virtualhost>
	