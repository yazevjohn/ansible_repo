
server {
    listen   80;
    #listen   83;
    #listen   443 ssl;
    server_name search.b2b-logist.com;
    #ssl on;
    #ssl_protocols TLSv1.2 TLSv1.1 TLSv1;
    #ssl_certificate /etc/nginx/ssl/b2b-logist.crt;
    #ssl_certificate_key /etc/nginx/ssl/b2b-logist.key;

    #verion control
	location ~ /\.ht { deny all; }
	location ~ /\.svn { deny all; }
	location ~ /\.git { deny all; }
	location ~ /\. { deny all; }

	location /nginx-status {
	include /etc/nginx/naxsi.rules;
	if ($white_ip != '1')
	{
	    error_page   412  = @nocache;
	    return 412;
	}

	#allow 127.0.0.1;
	allow all;
	#deny all;
	access_log  off;
	stub_status on;
    }

location @RequestDenied {

    access_log /var/log/nginx/attack.log;
#    return 500;
    error_page   412  = @nocache;
    return 412;

 }
    
	location / {
	include /etc/nginx/naxsi.rules;
	error_page   412  = @nocache;
	return 412;
    }

    location @nocache {
	#limit_req zone=delay_zone1 burst=50;
	#limit_conn delay_zone2 32;

	proxy_pass http://search_upstream;
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $remote_addr;
	proxy_set_header X-Host $http_host;
	proxy_set_header X-URI $uri;
	proxy_set_header X-ARGS $args;
	proxy_set_header Refer $http_refer;
	proxy_cache off;
	
    }

}

server {
    #listen   80;
    #listen   83;
    listen   443 ssl;
    server_name search.b2b-logist.com;
    #ssl on;
    ssl_protocols TLSv1.2 TLSv1.1 TLSv1;
    ssl_certificate /etc/nginx/ssl/b2b-logist.com.crt;
    ssl_certificate_key /etc/nginx/ssl/b2b-logist.com.key;

    #verion control
	location ~ /\.ht { deny all; }
	location ~ /\.svn { deny all; }
	location ~ /\.git { deny all; }
	location ~ /\. { deny all; }

	location /nginx-status {
	include /etc/nginx/naxsi.rules;
	if ($white_ip != '1')
	{
	    error_page   412  = @nocache;
	    return 412;
	}

	#allow 127.0.0.1;
	allow all;
	#deny all;
	access_log  off;
	stub_status on;
    }

location @RequestDenied {

    access_log /var/log/nginx/attack.log;
#    return 500;
    error_page   412  = @nocache;
    return 412;

 }
    
	location / {
	include /etc/nginx/naxsi.rules;
	error_page   412  = @nocache;
	return 412;
    }

    location @nocache {
	#limit_req zone=delay_zone1 burst=50;
	#limit_conn delay_zone2 32;

	proxy_pass http://search_upstream;
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $remote_addr;
	proxy_set_header X-Host $http_host;
	proxy_set_header X-URI $uri;
	proxy_set_header X-ARGS $args;
	proxy_set_header Refer $http_refer;
	proxy_cache off;
	
    }

}