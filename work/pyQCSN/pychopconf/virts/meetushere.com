<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName meetushere.com
        ServerAlias *.meetushere.com
        ServerAdmin webmaster@meetushere.com
        DocumentRoot /home/httpd/virtual//meetushere.com/docs/
        ErrorLog  /home/httpd/virtual//meetushere.com/logs/error
        CustomLog /home/httpd/virtual//meetushere.com/logs/access combined
        ScriptLog /home/httpd/virtual//meetushere.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//meetushere.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//meetushere.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	