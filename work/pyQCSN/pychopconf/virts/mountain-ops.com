<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName mountain-ops.com
        ServerAlias *.mountain-ops.com
        ServerAdmin webmaster@mountain-ops.com
        DocumentRoot /home/httpd/virtual//mountain-ops.com/docs/
        ErrorLog  /home/httpd/virtual//mountain-ops.com/logs/error
        CustomLog /home/httpd/virtual//mountain-ops.com/logs/access combined
        ScriptLog /home/httpd/virtual//mountain-ops.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//mountain-ops.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//mountain-ops.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	