<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName storksrabbitsandcabbagepatches.com
        ServerAlias *.storksrabbitsandcabbagepatches.com
        ServerAdmin webmaster@storksrabbitsandcabbagepatches.com
        DocumentRoot /home/httpd/virtual//storksrabbitsandcabbagepatches.com/docs/
        ErrorLog  /home/httpd/virtual//storksrabbitsandcabbagepatches.com/logs/error
        CustomLog /home/httpd/virtual//storksrabbitsandcabbagepatches.com/logs/access combined
        ScriptLog /home/httpd/virtual//storksrabbitsandcabbagepatches.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//storksrabbitsandcabbagepatches.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//storksrabbitsandcabbagepatches.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	