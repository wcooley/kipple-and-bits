<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName reversingmachines.com
	ServerAlias *.reversingmachines.com
	ServerAdmin webmaster@reversingmachines.com
	DocumentRoot /home/httpd/virtual/reversingmachines.com
	ErrorLog /var/log/httpd/reversingmachines.com/error
	CustomLog /var/log/httpd/reversingmachines.com/access combined
	ScriptLog /var/log/httpd/reversingmachines.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/reversingmachines.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	