<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName thetroutdalecommunity.com
        ServerAlias *.thetroutdalecommunity.com
        ServerAdmin webmaster@thetroutdalecommunity.com
        DocumentRoot /home/httpd/virtual//thetroutdalecommunity.com/docs/
        ErrorLog  /home/httpd/virtual//thetroutdalecommunity.com/logs/error
        CustomLog /home/httpd/virtual//thetroutdalecommunity.com/logs/access combined
        ScriptLog /home/httpd/virtual//thetroutdalecommunity.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//thetroutdalecommunity.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//thetroutdalecommunity.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	