<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName greshamlandscape.com
	ServerAlias *.greshamlandscape.com
	ServerAlias greshamlandscape.com
	ServerAdmin webmaster@greshamlandscape.com
	DocumentRoot /home/httpd/virtual/greshamlandscape.com
	ErrorLog /var/log/httpd/greshamlandscape.com/error
	CustomLog /var/log/httpd/greshamlandscape.com/access combined
	ScriptLog /var/log/httpd/greshamlandscape.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/greshamlandscape.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	