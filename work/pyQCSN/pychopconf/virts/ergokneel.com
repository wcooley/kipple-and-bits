<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName ergokneel.com
        ServerAlias *.ergokneel.com
        ServerAdmin webmaster@ergokneel.com
        DocumentRoot /home/httpd/virtual//ergokneel.com/docs/
        ErrorLog  /home/httpd/virtual//ergokneel.com/logs/error
        CustomLog /home/httpd/virtual//ergokneel.com/logs/access combined
        ScriptLog /home/httpd/virtual//ergokneel.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//ergokneel.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//ergokneel.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	