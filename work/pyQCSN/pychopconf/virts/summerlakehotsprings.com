<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName summerlakehotsprings.com
	ServerAlias *.summerlakehotsprings.com
	ServerAlias summerlakehotsprings.com
	ServerAdmin webmaster@summerlakehotsprings.com
	DocumentRoot /home/httpd/virtual/summerlakehotsprings.com
	ErrorLog /var/log/httpd/summerlakehotsprings.com/error
	CustomLog /var/log/httpd/summerlakehotsprings.com/access combined
	ScriptLog /var/log/httpd/summerlakehotsprings.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/summerlakehotsprings.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	