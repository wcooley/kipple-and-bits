<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName simplesolarworks.com
        ServerAlias *.simplesolarworks.com
        ServerAdmin webmaster@simplesolarworks.com
        DocumentRoot /home/httpd/virtual//simplesolarworks.com/docs/
        ErrorLog  /home/httpd/virtual//simplesolarworks.com/logs/error
        CustomLog /home/httpd/virtual//simplesolarworks.com/logs/access combined
        ScriptLog /home/httpd/virtual//simplesolarworks.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//simplesolarworks.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//simplesolarworks.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	