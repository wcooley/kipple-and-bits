<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@community-search.com
	DocumentRoot /home/httpd/virtual/test.community-search.com
	ServerName test.community-search.com
	Options All
	ErrorLog /var/log/httpd/community-search.com/error
	CustomLog /var/log/httpd/community-search.com/test_access combined 
	ScriptAlias /cgi-bin/ /home/httpd/virtual/test.community-search.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	AddHandler cgi-script cgi
</Virtualhost>
	