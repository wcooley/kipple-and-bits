<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName bestservicecompany.com
        ServerAlias *.bestservicecompany.com
        ServerAdmin webmaster@bestservicecompany.com
        DocumentRoot /home/httpd/virtual//bestservicecompany.com/docs/
        ErrorLog  /home/httpd/virtual//bestservicecompany.com/logs/error
        CustomLog /home/httpd/virtual//bestservicecompany.com/logs/access combined
        ScriptLog /home/httpd/virtual//bestservicecompany.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//bestservicecompany.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//bestservicecompany.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	