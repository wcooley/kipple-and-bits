<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName tildeathdoyoupart.com
        ServerAlias *.tildeathdoyoupart.com
        ServerAdmin webmaster@tildeathdoyoupart.com
        DocumentRoot /home/httpd/virtual//tildeathdoyoupart.com/docs/
        ErrorLog  /home/httpd/virtual//tildeathdoyoupart.com/logs/error
        CustomLog /home/httpd/virtual//tildeathdoyoupart.com/logs/access combined
        ScriptLog /home/httpd/virtual//tildeathdoyoupart.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//tildeathdoyoupart.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//tildeathdoyoupart.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	