<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName thegorgecommunity.com
        ServerAlias *.thegorgecommunity.com
        ServerAdmin webmaster@thegorgecommunity.com
        DocumentRoot /home/httpd/virtual//thegorgecommunity.com/docs/
        ErrorLog  /home/httpd/virtual//thegorgecommunity.com/logs/error
        CustomLog /home/httpd/virtual//thegorgecommunity.com/logs/access combined
        ScriptLog /home/httpd/virtual//thegorgecommunity.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//thegorgecommunity.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//thegorgecommunity.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	