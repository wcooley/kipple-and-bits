<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName sanitrux.com
        ServerAlias *.sanitrux.com
        ServerAdmin webmaster@sanitrux.com
        DocumentRoot /home/httpd/virtual//sanitrux.com/docs/
        ErrorLog  /home/httpd/virtual//sanitrux.com/logs/error
        CustomLog /home/httpd/virtual//sanitrux.com/logs/access combined
        ScriptLog /home/httpd/virtual//sanitrux.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//sanitrux.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//sanitrux.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	