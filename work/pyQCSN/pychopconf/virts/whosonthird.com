<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName whosonthird.com
        ServerAlias *.whosonthird.com
        ServerAdmin webmaster@whosonthird.com
        DocumentRoot /home/httpd/virtual//whosonthird.com/docs/
        ErrorLog  /home/httpd/virtual//whosonthird.com/logs/error
        CustomLog /home/httpd/virtual//whosonthird.com/logs/access combined
        ScriptLog /home/httpd/virtual//whosonthird.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//whosonthird.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//whosonthird.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	