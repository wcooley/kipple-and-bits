<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName mandmlounge.com
        ServerAlias *.mandmlounge.com
        ServerAdmin webmaster@mandmlounge.com
        DocumentRoot /home/httpd/virtual//mandmlounge.com/docs/
        ErrorLog  /home/httpd/virtual//mandmlounge.com/logs/error
        CustomLog /home/httpd/virtual//mandmlounge.com/logs/access combined
        ScriptLog /home/httpd/virtual//mandmlounge.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//mandmlounge.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//mandmlounge.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	