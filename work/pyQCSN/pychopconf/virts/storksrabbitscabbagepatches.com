<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName storksrabbitscabbagepatches.com
        ServerAlias *.storksrabbitscabbagepatches.com
        ServerAdmin webmaster@storksrabbitscabbagepatches.com
        DocumentRoot /home/httpd/virtual//storksrabbitscabbagepatches.com/docs/
        ErrorLog  /home/httpd/virtual//storksrabbitscabbagepatches.com/logs/error
        CustomLog /home/httpd/virtual//storksrabbitscabbagepatches.com/logs/access combined
        ScriptLog /home/httpd/virtual//storksrabbitscabbagepatches.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//storksrabbitscabbagepatches.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//storksrabbitscabbagepatches.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	