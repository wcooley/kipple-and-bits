<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName thehiredgun.com
	ServerAlias *.thehiredgun.com
	ServerAdmin webmaster@thehiredgun.com
	DocumentRoot /home/httpd/virtual/thehiredgun.com
	ErrorLog /var/log/httpd/thehiredgun.com/error
	CustomLog /var/log/httpd/thehiredgun.com/access combined
	ScriptAlias /cgi-bin/ /home/httpd/virtual/thehiredgun.com/cgi-bin
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/
	Alias /stats/ /home/httpd/stats/thehiredgun.com/
</Virtualhost>
	