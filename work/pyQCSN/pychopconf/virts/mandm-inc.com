<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/mandm-inc.com
	ServerName mandm-inc.com
	ServerAlias *.mandm-inc.com
	ErrorLog /var/log/httpd/mandm-inc.com/error
	CustomLog /var/log/httpd/mandm-inc.com/access combined
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	Alias /stats/ /home/httpd/stats/mandm-inc.com/
</VirtualHost>
	