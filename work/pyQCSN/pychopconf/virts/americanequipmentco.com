<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName americanequipmentco.com
	ServerAlias *.americanequipmentco.com
	ServerAdmin webmaster@americanequipmentco.com
	DocumentRoot /home/httpd/virtual/americanequipmentco.com
	ErrorLog /var/log/httpd/americanequipmentco.com/error
	CustomLog /var/log/httpd/americanequipmentco.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/americanequipmentco.com/cgi-bin
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</Virtualhost>
	