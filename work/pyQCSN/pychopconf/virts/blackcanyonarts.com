<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName blackcanyonarts.com
	ServerAlias *.blackcanyonarts.com
	ServerAdmin webmaster@blackcanyonarts.com
	DocumentRoot /home/httpd/virtual/blackcanyonarts.com
	ErrorLog /var/log/httpd/blackcanyonarts.com/error
	CustomLog /var/log/httpd/blackcanyonarts.com/access combined
	ScriptLog /var/log/httpd/blackcanyonarts.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/blackcanyonarts.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	