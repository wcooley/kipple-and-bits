<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/html/admin
	ServerName admin.qcsn.com
	CustomLog /var/log/httpd/qcsn.com/admin_access combined
	ErrorLog /var/log/httpd/admin_error
	ScriptAlias /cgi-bin/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	<Directory /home/httpd/html/admin/mrtg>
		MetaFiles ON
	</Directory>
</Virtualhost>
	