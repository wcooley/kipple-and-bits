<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName morethanslugs.com
        ServerAlias *.morethanslugs.com
        ServerAdmin webmaster@morethanslugs.com
        DocumentRoot /home/httpd/virtual//morethanslugs.com/docs/
        ErrorLog  /home/httpd/virtual//morethanslugs.com/logs/error
        CustomLog /home/httpd/virtual//morethanslugs.com/logs/access combined
        ScriptLog /home/httpd/virtual//morethanslugs.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//morethanslugs.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//morethanslugs.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	