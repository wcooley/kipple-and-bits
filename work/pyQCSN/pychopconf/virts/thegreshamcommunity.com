<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName thegreshamcommunity.com
        ServerAlias *.thegreshamcommunity.com
        ServerAdmin webmaster@thegreshamcommunity.com
        DocumentRoot /home/httpd/virtual//thegreshamcommunity.com/docs/
        ErrorLog  /home/httpd/virtual//thegreshamcommunity.com/logs/error
        CustomLog /home/httpd/virtual//thegreshamcommunity.com/logs/access combined
        ScriptLog /home/httpd/virtual//thegreshamcommunity.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//thegreshamcommunity.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//thegreshamcommunity.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	