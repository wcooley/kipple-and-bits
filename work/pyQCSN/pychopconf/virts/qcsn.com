<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@qcsn.com
	DocumentRoot /home/httpd/html
	ServerName qcsn.com
	ServerAlias *.qcsn.com
	ServerAlias qcsn.com fleetwood.qcsn.com
	ErrorLog /var/log/httpd/error
	CustomLog /var/log/httpd/qcsn.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	<Directory /home/packages>
	Options +Indexes +SymlinksIfOwnerMatch
	</Directory>
	Alias /packages/ /home/packages/
</Virtualhost>
	