<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName tehmountaincommunity.com
        ServerAlias *.tehmountaincommunity.com
        ServerAdmin webmaster@tehmountaincommunity.com
        DocumentRoot /home/httpd/virtual//tehmountaincommunity.com/docs/
        ErrorLog  /home/httpd/virtual//tehmountaincommunity.com/logs/error
        CustomLog /home/httpd/virtual//tehmountaincommunity.com/logs/access combined
        ScriptLog /home/httpd/virtual//tehmountaincommunity.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//tehmountaincommunity.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//tehmountaincommunity.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	