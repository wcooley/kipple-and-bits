<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName chairsbymarycay.com
	ServerAlias *.chairsbymarycay.com
	ServerAdmin webmaster@chairsbymarycay.com
	DocumentRoot /home/httpd/virtual/chairsbymarycay.com
	ErrorLog /var/log/httpd/chairsbymarycay.com/error
	CustomLog /var/log/httpd/chairsbymarycay.com/access combined
	ScriptLog /var/log/httpd/chairsbymarycay.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/chairsbymarycay.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	