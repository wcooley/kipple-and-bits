<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName wewantavacation.com
        ServerAlias *.wewantavacation.com
        ServerAdmin webmaster@wewantavacation.com
        DocumentRoot /home/httpd/virtual//wewantavacation.com/docs/
        ErrorLog  /home/httpd/virtual//wewantavacation.com/logs/error
        CustomLog /home/httpd/virtual//wewantavacation.com/logs/access combined
        ScriptLog /home/httpd/virtual//wewantavacation.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//wewantavacation.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//wewantavacation.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	