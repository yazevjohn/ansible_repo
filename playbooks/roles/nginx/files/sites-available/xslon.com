
server {
    listen   80;
    server_name new.xslon.com www.xslon.com xslon.com;

#   location ~ /\.ht { deny all; }
#   location ~ /\.svn { deny all; }
#   location ~ /\.git { deny all; }
#   location ~ /\. { deny all; }

#   location /nginx-status {
#	include /etc/nginx/naxsi.rules;
#	if ($white_ip != '1')
	#{
	#    error_page   412  = @nocache;
	#    return 412;
	#}

	#allow 127.0.0.1;
	#allow all;
	#deny all;
	#access_log  off;
	#stub_status on;
    #}


   

location / {


        proxy_pass http://xslon;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        #proxy_cache off;
        }



}

