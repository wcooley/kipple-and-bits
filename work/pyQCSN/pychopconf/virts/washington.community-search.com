<VirtualHost 198.145.93.8 65.201.55.8>
	ServerAdmin webmaster@community-search.com
	ServerName washington.community-search.com
	RedirectPermanent / http://www.community-search.com/wa/
</VirtualHost>
	