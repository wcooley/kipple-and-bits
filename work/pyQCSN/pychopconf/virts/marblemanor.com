<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/virtual/marblemanor.com
	ServerName marblemanor.com
	ServerAlias *.marblemanor.com
	ErrorLog /var/log/httpd/marblemanor.com/error
	CustomLog /var/log/httpd/marblemanor.com/access combined
	ScriptAlias /syscgi/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
</VirtualHost>
	