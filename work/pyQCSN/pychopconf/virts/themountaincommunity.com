<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName themountaincommunity.com
        ServerAlias *.themountaincommunity.com
        ServerAdmin webmaster@themountaincommunity.com
        DocumentRoot /home/httpd/virtual//themountaincommunity.com/docs/
        ErrorLog  /home/httpd/virtual//themountaincommunity.com/logs/error
        CustomLog /home/httpd/virtual//themountaincommunity.com/logs/access combined
        ScriptLog /home/httpd/virtual//themountaincommunity.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//themountaincommunity.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//themountaincommunity.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	