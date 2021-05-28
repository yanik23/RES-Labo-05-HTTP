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
<?php
	foreach ($dynamic_app as &$dynamicIp){
		echo "	BalancerMember http://". $dynamicIp . "\n";
	}
?>
	</Proxy>
	
	<Proxy balancer://staticBalancer>
<?php
	foreach ($static_app as &$staticIp){
		echo "	BalancerMember http://". $staticIp . "\n";
	}
?>
	</Proxy>
	
	
	ProxyPass '/api/students/' 'balancer://dynamicBalancer/'
	ProxyPassReverse '/api/students/' 'balancer://dynamicBalancer/'
	
	ProxyPass '/' 'balancer://staticBalancer/'
	ProxyPassReverse '/' 'balancer://staticBalancer/'
	
</VirtualHost>
