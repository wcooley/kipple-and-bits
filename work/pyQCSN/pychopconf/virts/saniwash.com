<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName saniwash.com
        ServerAlias *.saniwash.com
        ServerAdmin webmaster@saniwash.com
        DocumentRoot /home/httpd/virtual//saniwash.com/docs/
        ErrorLog  /home/httpd/virtual//saniwash.com/logs/error
        CustomLog /home/httpd/virtual//saniwash.com/logs/access combined
        ScriptLog /home/httpd/virtual//saniwash.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//saniwash.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//saniwash.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	