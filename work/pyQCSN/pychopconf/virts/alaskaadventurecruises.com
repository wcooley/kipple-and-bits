<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName alaskaadventurecruises.com
	ServerAlias *.alaskaadventurecruises.com
	ServerAdmin webmaster@alaskaadventurecruises.com
	DocumentRoot /home/httpd/virtual/alaskaadventurecruises.com
	ErrorLog /var/log/httpd/alaskaadventurecruises.com/error
	CustomLog /var/log/httpd/alaskaadventurecruises.com/access combined
	ScriptLog /var/log/httpd/alaskaadventurecruises.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/alaskaadventurecruises.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	