<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName thatshoparoundthecorner.com
        ServerAlias *.thatshoparoundthecorner.com
        ServerAdmin webmaster@thatshoparoundthecorner.com
        DocumentRoot /home/httpd/virtual//thatshoparoundthecorner.com/docs/
        ErrorLog  /home/httpd/virtual//thatshoparoundthecorner.com/logs/error
        CustomLog /home/httpd/virtual//thatshoparoundthecorner.com/logs/access combined
        ScriptLog /home/httpd/virtual//thatshoparoundthecorner.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//thatshoparoundthecorner.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//thatshoparoundthecorner.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	