<VirtualHost 198.145.93.8 65.201.55.8>
	ServerName americanequip.com
	ServerAlias *.americanequip.com
	RedirectPermanent / http://www.americanequipmentco.com
</Virtualhost>
	