<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName thegoldenflyer.com
        ServerAlias *.thegoldenflyer.com
        ServerAdmin webmaster@thegoldenflyer.com
        DocumentRoot /home/httpd/virtual//thegoldenflyer.com/docs/
        ErrorLog  /home/httpd/virtual//thegoldenflyer.com/logs/error
        CustomLog /home/httpd/virtual//thegoldenflyer.com/logs/access combined
        ScriptLog /home/httpd/virtual//thegoldenflyer.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//thegoldenflyer.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//thegoldenflyer.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	