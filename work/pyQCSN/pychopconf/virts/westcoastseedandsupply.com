<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName westcoastseedandsupply.com
        ServerAlias *.westcoastseedandsupply.com
        ServerAdmin webmaster@westcoastseedandsupply.com
        DocumentRoot /home/httpd/virtual//westcoastseedandsupply.com/
        ErrorLog  /var/log/httpd/westcoastseedandsupply.com/error
        CustomLog /var/log/httpd/westcoastseedandsupply.com/access combined
        ScriptLog /var/log/httpd/westcoastseedandsupply.com/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//westcoastseedandsupply.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//westcoastseedandsupply.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	