<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName halloraninvestigations.com
	ServerAlias *.halloraninvestigations.com
	ServerAdmin webmaster@halloraninvestigations.com
	DocumentRoot /home/httpd/virtual/halloraninvestigations.com
	ErrorLog /var/log/httpd/halloraninvestigations.com/error
	CustomLog /var/log/httpd/halloraninvestigations.com/access combined
	ScriptLog /var/log/httpd/halloraninvestigations.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/halloraninvestigations.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
	Alias /stats/ /home/httpd/stats/halloraninvestigations.com/
</Virtualhost>
	