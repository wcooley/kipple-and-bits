<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName buzzbeecafe.com
        ServerAlias *.buzzbeecafe.com
        ServerAdmin webmaster@buzzbeecafe.com
        DocumentRoot /home/httpd/virtual//buzzbeecafe.com/docs/
        ErrorLog  /home/httpd/virtual//buzzbeecafe.com/logs/error
        CustomLog /home/httpd/virtual//buzzbeecafe.com/logs/access combined
        ScriptLog /home/httpd/virtual//buzzbeecafe.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//buzzbeecafe.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//buzzbeecafe.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	