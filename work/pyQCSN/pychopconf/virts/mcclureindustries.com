<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName mcclureindustries.com
        ServerAlias *.mcclureindustries.com
        ServerAdmin webmaster@mcclureindustries.com
        DocumentRoot /home/httpd/virtual//mcclureindustries.com/docs/
        ErrorLog  /home/httpd/virtual//mcclureindustries.com/logs/error
        CustomLog /home/httpd/virtual//mcclureindustries.com/logs/access combined
        ScriptLog /home/httpd/virtual//mcclureindustries.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//mcclureindustries.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//mcclureindustries.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	