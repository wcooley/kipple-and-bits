<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName theboringcommunity.com
        ServerAlias *.theboringcommunity.com
        ServerAdmin webmaster@theboringcommunity.com
        DocumentRoot /home/httpd/virtual//theboringcommunity.com/docs/
        ErrorLog  /home/httpd/virtual//theboringcommunity.com/logs/error
        CustomLog /home/httpd/virtual//theboringcommunity.com/logs/access combined
        ScriptLog /home/httpd/virtual//theboringcommunity.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//theboringcommunity.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//theboringcommunity.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	