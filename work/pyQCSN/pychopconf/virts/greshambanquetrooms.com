<VirtualHost 198.145.93.8 65.201.55.8>
        ServerName greshambanquetrooms.com
        ServerAlias *.greshambanquetrooms.com
        ServerAdmin webmaster@greshambanquetrooms.com
        DocumentRoot /home/httpd/virtual//greshambanquetrooms.com/docs/
        ErrorLog  /home/httpd/virtual//greshambanquetrooms.com/logs/error
        CustomLog /home/httpd/virtual//greshambanquetrooms.com/logs/access combined
        ScriptLog /home/httpd/virtual//greshambanquetrooms.com/logs/script
        ScriptAlias /cgi-bin/ /home/httpd/virtual//greshambanquetrooms.com/cgi-bin/
        ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
        Alias /stats/ /home/httpd/virtual//greshambanquetrooms.com/stats/
	<IfModule mod_bandwidth.c>
        	BandWidthModule on
        	BandWidth all 16384
		MinBandwidth all 8192
	</IfModule>

</Virtualhost>
	