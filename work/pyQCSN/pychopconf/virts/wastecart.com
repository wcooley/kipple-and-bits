<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName wastecart.com
        ServerAlias *.wastecart.com
        ServerAdmin webmaster@wastecart.com
        DocumentRoot /home/httpd/virtual//wastecart.com/docs/
        ErrorLog  /home/httpd/virtual//wastecart.com/logs/error
        CustomLog /home/httpd/virtual//wastecart.com/logs/access combined
        ScriptLog /home/httpd/virtual//wastecart.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//wastecart.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//wastecart.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	