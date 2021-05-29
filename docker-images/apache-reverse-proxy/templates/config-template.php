<?php
	$dynamic_app = getenv('DYNAMIC_APP');
	$static_app = getenv('STATIC_APP');
?>
<VirtualHost *:80>
	ServerName demo.res.ch
	
	ProxyPass '/api/animals/' 'http://<?php print "$dynamic_app"?>:3000/'
	ProxyPassReverse '/api/animals/' 'http://<?php print "$dynamic_app"?>:3000/'
	
	ProxyPass '/' 'http://<?php print "$static_app"?>:80/'
	ProxyPassReverse '/' 'http://<?php print "$static_app"?>:80/'	
</VirtualHost>
