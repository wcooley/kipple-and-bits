<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName laundrycart.com
        ServerAlias *.laundrycart.com
        ServerAdmin webmaster@laundrycart.com
        DocumentRoot /home/httpd/virtual//laundrycart.com/docs/
        ErrorLog  /home/httpd/virtual//laundrycart.com/logs/error
        CustomLog /home/httpd/virtual//laundrycart.com/logs/access combined
        ScriptLog /home/httpd/virtual//laundrycart.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//laundrycart.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//laundrycart.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	