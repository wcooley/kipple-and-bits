<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName thesandycommunity.com
        ServerAlias *.thesandycommunity.com
        ServerAdmin webmaster@thesandycommunity.com
        DocumentRoot /home/httpd/virtual//thesandycommunity.com/docs/
        ErrorLog  /home/httpd/virtual//thesandycommunity.com/logs/error
        CustomLog /home/httpd/virtual//thesandycommunity.com/logs/access combined
        ScriptLog /home/httpd/virtual//thesandycommunity.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//thesandycommunity.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//thesandycommunity.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	