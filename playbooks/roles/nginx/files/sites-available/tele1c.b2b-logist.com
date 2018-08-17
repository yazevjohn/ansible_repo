server { 
	listen 80; 
	server_name tele1c.b2b-logist.com; 

	#location / { 
	#	return 301 https://$server_name$request_uri; 
	#}

	location /availability/ { 
		return 301 https://$server_name; 

		#include 1c_common.conf;
		#recursive_error_pages on; 
		#error_page 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 500 501 502 503 504 505 /i/index.html; 
		#proxy_pass http://upstream_availability; 
	} 

	location /i/ { 
		alias /var/www/failover/;
	} 

location /a/ {
                include 1c_common.conf;
                include 1c_keepalive.conf;
                include 1c_error_openid.conf;
                proxy_pass http://backend83;
        }
location / { 
return 301 https://$server_name/a/adm;

		include 1c_common.conf; 
		include 1c_keepalive.conf; 
		include 1c_error_site.conf; 
		proxy_pass http://site; 
	} 

	location /resources/images/content { 
		#alias /var/www/static/media; 
		include 1c_common.conf; 
		include 1c_keepalive.conf; 
		include 1c_error_site.conf; 
		proxy_pass http://site_media; 

	} 
	location /admin {
	    if ($white_ip = '0')
    	    {
        	error_page   412  = @RequestDenied;
        	return 412;
    	    }
 
		include 1c_common.conf; 
		include 1c_keepalive.conf; 
		include 1c_error_site.conf; 
		proxy_pass http://site; 
	}
	
	location /settings {
	    if ($white_ip = '0')
    	    {
            error_page   412  = @RequestDenied;
            return 412;
    	    }
 
		include 1c_common.conf; 
		include 1c_keepalive.conf; 
		include 1c_error_site.conf; 
		proxy_pass http://site; 
	}
	
	
location @RequestDenied {

    access_log /var/log/nginx/attack.log;
#    return 500;                                                                
    #error_page   412  = @nocache;
    return 500;

 } 
}

server { 
	listen 8888; 
	server_name tele1c.b2b-logist.com; 

	location / { 
		include 1c_common.conf; 
		include 1c_keepalive.conf; 
		include 1c_error_openid.conf; 
		proxy_pass http://backend83;
 
	} 
}

server { 
	listen 443 ssl; 
	server_name tele1c.b2b-logist.com; 
	proxy_intercept_errors on; 
	ssl on; 
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; 
	#ssl_ciphers RC4:HIGH:!aNULL:!MD5:!kEDH; 
	#ssl_ciphers 'AES128+EECDH:AES128+EDH:!aNULL';	
	#ssl_protocols TLSv1.2;
	#ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
    
	#ssl_prefer_server_ciphers on; 
	
	#ssl_session_cache shared:SSL:10m;
	#ssl_stapling on;
	#ssl_stapling_verify on;
	#resolver 8.8.4.4 8.8.8.8 valid=300s;
	#ssl_dhparam /etc/nginx/ssl/dhparam.pem;
	#resolver_timeout 10s;
	#add_header Strict-Transport-Security max-age=63072000;
	#add_header X-Frame-Options DENY;
	#add_header X-Content-Type-Options nosniff;

	#ssl_certificate /etc/nginx/ssl/tele1c.com.crt;
	#ssl_certificate_key /etc/nginx/ssl/tele1c.com.key;
    
	ssl_certificate /etc/nginx/ssl/b2b-logist.com.crt;
	ssl_certificate_key /etc/nginx/ssl/b2b-logist.com.key;

	#ssl_session_cache shared:SSL:10m; 
	#ssl_session_timeout 10m;
	
#	root /var/www/tele1c.com/www;
#	error_page   500 502 503 504 /503.txt;
#        location = /503.txt {
#            root   html;
#        }

#	location /a/adm/ws/
#{
            #error_page   412  = @RequestDenied;
	#error_page   503 = /etc/nginx/html/503.txt;
	#error_page   503 = /etc/nginx/html/503.txt;
#	set $mode txt;     
	#try_files /etc/nginx/html/503.txt;
#       try_files $uri $uri/ /503.txt;
#	return 503;

#}
#	location @start { 
#		rewrite ^(/a/[a-zA-Z0-9_]+/([0-9]+/)?).*$ $1 last; 
#	} 

	location /availability/ { 
		return 301 https://$server_name; 

		#include 1c_common.conf;
		#recursive_error_pages on; 
		#error_page 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 500 501 502 503 504 505 /i/index.html; 
		#proxy_pass http://upstream_availability; 
	} 

	location /i/ { 
		alias /var/www/failover/;
	} 

location /a/ {
                include 1c_common.conf;
                include 1c_keepalive.conf;
                include 1c_error_openid.conf;
                proxy_pass http://backend83;
        }

	#location ^~ /a/openid { 
	#	include 1c_common.conf; 
	#	include 1c_keepalive.conf; 
	#	include 1c_error_openid.conf; 
	#	proxy_pass http://backend83;
	#} 

	#location ^~ /a/adm/e1cib/start { 
	#	include 1c_app.conf; 
	#	include 1c_error.conf; 
	#	include 1c_keepalive.conf; 
	#	error_page 400 403 412 @start; 
	#	proxy_pass http://backend83; 
	#} 

	#location ^~ /a/adm { 
	#	include 1c_app.conf; 
	#	include 1c_error.conf; 
	#	include 1c_keepalive.conf; 
	#	proxy_pass http://backend83; 
	#} 

	#location ~* /a/\w+/\d+/e1cib/start { 
	#	include 1c_app.conf; 
	#	include 1c_error.conf; 
	#	error_page 400 403 412 @start; 
	#	proxy_pass http://gate; 
	#} 

	#location ~* /a/\w+/\d+/\w+/e1cib/oid2rp { 
	#	include 1c_app.conf; 
	#	include 1c_error.conf; 
	#	error_page 400 403 404 412 @start; 
	#	proxy_pass http://gate; 
	#} 

	#location ~* /a/\w+/\d+/ws { 
	#	include 1c_app.conf; 
	#	proxy_intercept_errors off; 
	#	proxy_pass http://gate; 
	#} 

	#location ~* /a/\w+/\d+ { 
	#	include 1c_app.conf; 
	#	include 1c_error.conf;
	#	proxy_pass http://gate; 
	#} 

	location / { 
return 301 https://$server_name/a/adm;
		include 1c_common.conf; 
		include 1c_keepalive.conf; 
		include 1c_error_site.conf; 
		proxy_pass http://site; 
	} 

#	location /resources/images/content { 
#		alias /var/www/static/media; 
#}
	location /resources/images/content { 
		#alias /var/www/static/media; 
		include 1c_common.conf; 
		include 1c_keepalive.conf; 
		include 1c_error_site.conf; 
		proxy_pass http://site_media; 

	} 
	location /admin {
	    if ($white_ip = '0')
    	    {
        	error_page   412  = @RequestDenied;
        	return 412;
    	    }
 
		include 1c_common.conf; 
		include 1c_keepalive.conf; 
		include 1c_error_site.conf; 
		proxy_pass http://site; 
	}
	
	location /settings {
	    if ($white_ip = '0')
    	    {
            error_page   412  = @RequestDenied;
            return 412;
    	    }
 
		include 1c_common.conf; 
		include 1c_keepalive.conf; 
		include 1c_error_site.conf; 
		proxy_pass http://site; 
	}
	
	
location @RequestDenied {

    access_log /var/log/nginx/attack.log;
#    return 500;                                                                
    #error_page   412  = @nocache;
    return 500;

 }

}

