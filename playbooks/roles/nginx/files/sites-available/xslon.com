
server {
    listen   80;
    server_name new.xslon.com www.xslon.com xslon.com;

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
		#dgasfg;
        }



}

