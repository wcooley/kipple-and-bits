<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName softknees.com
        ServerAlias *.softknees.com
        ServerAdmin webmaster@softknees.com
        DocumentRoot /home/httpd/virtual//softknees.com/docs/
        ErrorLog  /home/httpd/virtual//softknees.com/logs/error
        CustomLog /home/httpd/virtual//softknees.com/logs/access combined
        ScriptLog /home/httpd/virtual//softknees.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//softknees.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//softknees.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	