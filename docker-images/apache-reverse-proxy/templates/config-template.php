<?php

	$dynamic_app = explode(',', getenv('DYNAMIC_APP'));
	$static_app = explode(',', getenv('STATIC_APP'));
	
	//$dynamic_app = getenv('DYNAMIC_APP');
	//$static_app = getenv('STATIC_APP');
?>
<VirtualHost *:80>
	ServerName demo.res.ch
	
	ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
	<Proxy balancer://dynamicBalancer>

	#dynamicBalancer
	</Proxy>
	
	<Proxy balancer://staticBalancer>

	#staticBalancer
	</Proxy>
	
	<Location /balancer-manager>
		SetHandler balancer-manager
		Order Deny,Allow
		Allow from all
	</Location>

	ProxyPass /balancer-manager !
	
	ProxyPass '/api/animals/' 'balancer://dynamicBalancer/'
	ProxyPassReverse '/api/animals/' 'balancer://dynamicBalancer/'
	
	ProxyPass '/' 'balancer://staticBalancer/'
	ProxyPassReverse '/' 'balancer://staticBalancer/'
	
</VirtualHost>
