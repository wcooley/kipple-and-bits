<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName quietcountrycrafts.com
        ServerAlias *.quietcountrycrafts.com
        ServerAdmin webmaster@quietcountrycrafts.com
        DocumentRoot /home/httpd/virtual//quietcountrycrafts.com/docs/
        ErrorLog  /home/httpd/virtual//quietcountrycrafts.com/logs/error
        CustomLog /home/httpd/virtual//quietcountrycrafts.com/logs/access combined
        ScriptLog /home/httpd/virtual//quietcountrycrafts.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//quietcountrycrafts.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//quietcountrycrafts.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	