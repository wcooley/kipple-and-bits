<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName bogeysingresham.com
        ServerAlias *.bogeysingresham.com
        ServerAdmin webmaster@bogeysingresham.com
        DocumentRoot /home/httpd/virtual//bogeysingresham.com/docs/
        ErrorLog  /home/httpd/virtual//bogeysingresham.com/logs/error
        CustomLog /home/httpd/virtual//bogeysingresham.com/logs/access combined
        ScriptLog /home/httpd/virtual//bogeysingresham.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//bogeysingresham.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//bogeysingresham.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	