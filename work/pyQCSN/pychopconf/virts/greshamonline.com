<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName greshamonline.com
        ServerAlias *.greshamonline.com
        ServerAdmin webmaster@greshamonline.com
        DocumentRoot /home/httpd/virtual//greshamonline.com/docs/
        ErrorLog  /home/httpd/virtual//greshamonline.com/logs/error
        CustomLog /home/httpd/virtual//greshamonline.com/logs/access combined
        ScriptLog /home/httpd/virtual//greshamonline.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//greshamonline.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual/greshamonline.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	