<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName homegrowngreetings.com
	ServerAlias *.homegrowngreetings.com
	ServerAdmin webmaster@homegrowngreetings.com
	DocumentRoot /home/httpd/virtual/homegrowngreetings.com
	ErrorLog /var/log/httpd/homegrowngreetings.com/error
	CustomLog /var/log/httpd/homegrowngreetings.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/homegrowngreetings.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</Virtualhost>
	