<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/html
	ServerName unimorph.qcsn.com
	CustomLog /var/log/httpd/qcsn.com/unimorph_access combined
	ErrorLog /var/log/httpd/error
	ScriptAlias /cgi-bin/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	<IfDefine SSL>
	SSLEngine On
	</IfDefine>
</Virtualhost>
	