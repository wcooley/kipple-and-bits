<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName mandmrestaurant.com
        ServerAlias *.mandmrestaurant.com
        ServerAdmin webmaster@mandmrestaurant.com
        DocumentRoot /home/httpd/virtual//mandmrestaurant.com/docs/
        ErrorLog  /home/httpd/virtual//mandmrestaurant.com/logs/error
        CustomLog /home/httpd/virtual//mandmrestaurant.com/logs/access combined
        ScriptLog /home/httpd/virtual//mandmrestaurant.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//mandmrestaurant.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//mandmrestaurant.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	