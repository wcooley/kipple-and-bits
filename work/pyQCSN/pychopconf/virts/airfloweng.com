<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName airfloweng.com
	ServerAlias *.airfloweng.com
	ServerAlias airfloweng.com
	ServerAdmin webmaster@airfloweng.com
	DocumentRoot /home/httpd/virtual/airfloweng.com
	ErrorLog /var/log/httpd/airfloweng.com/error
	CustomLog /var/log/httpd/airfloweng.com/access combined
	ScriptLog /var/log/httpd/airfloweng.com/script
	ScriptAlias /cgi-bin/ /home/httpd/virtual/airfloweng.com/cgi-bin/
	ScriptAlias /sys-bin/ /home/httpd/cgi-bin/ 
</Virtualhost>
	