<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName internationalnewssvc.com
	ServerAlias *.internationalnewssvc.com
	ServerAlias internationalnewssvc.com
	ServerAdmin webmaster@internationalnewssvc.com
	DocumentRoot /home/httpd/virtual/internationalnewssvc.com
	ErrorLog /var/log/httpd/internationalnewssvc.com/error
	CustomLog /var/log/httpd/internationalnewssvc.com/access combined
	ScriptLog /var/log/httpd/internationalnewssvc.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/internationalnewssvc.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	