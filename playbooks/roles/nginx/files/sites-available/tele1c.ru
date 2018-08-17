    server { 
	listen 80; 
	server_name tele1c.ru; 

	location / { 
		return 301 https://tele1c.com/$request_uri; 
	} 
}


server { 
	listen 443 ssl; 
	server_name tele1c.ru; 
	proxy_intercept_errors on; 
	ssl on; 
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; 
	#ssl_ciphers RC4:HIGH:!aNULL:!MD5:!kEDH; 
	ssl_ciphers 'AES128+EECDH:AES128+EDH:!aNULL';	
	ssl_prefer_server_ciphers on; 
	
	ssl_session_cache shared:SSL:10m;
	ssl_stapling on;
	ssl_stapling_verify on;
	resolver 8.8.4.4 8.8.8.8 valid=300s;
	ssl_dhparam /etc/nginx/ssl/dhparam.pem;
	resolver_timeout 10s;
	add_header Strict-Transport-Security max-age=63072000;
	#add_header X-Frame-Options DENY;
	add_header X-Frame-Options SAMEORIGIN;
	add_header X-Content-Type-Options nosniff;

	ssl_certificate /etc/nginx/ssl/tele1c.com.crt;
	ssl_certificate_key /etc/nginx/ssl/tele1c.com.key;
    
	#ssl_certificate /etc/nginx/ssl/b2b-logist.com.crt;
	#ssl_certificate_key /etc/nginx/ssl/b2b-logist.com.key;

	ssl_session_cache shared:SSL:10m; 
	ssl_session_timeout 10m;
	
	location / { 
		return 301 https://tele1c.ru/$request_uri; 
	} 

}

