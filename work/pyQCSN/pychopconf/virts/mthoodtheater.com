<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName mthoodtheater.com
        ServerAlias *.mthoodtheater.com
        ServerAdmin webmaster@mthoodtheater.com
        DocumentRoot /home/httpd/virtual//mthoodtheater.com/docs/
        ErrorLog  /home/httpd/virtual//mthoodtheater.com/logs/error
        CustomLog /home/httpd/virtual//mthoodtheater.com/logs/access combined
        ScriptLog /home/httpd/virtual//mthoodtheater.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//mthoodtheater.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//mthoodtheater.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	