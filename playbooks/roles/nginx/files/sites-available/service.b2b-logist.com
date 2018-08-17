
server {
    listen   80;
    #listen   83;
    #listen   443 ssl;
    server_name service.b2b-logist.com;
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
    #login
    #location ~*\/e1cib\/login11111 {

location ~*(/sl/)(.*)e1cib/login {
	include /etc/nginx/naxsi.rules;
	if ($white_ip = '1')
	{
	    error_page   412  = @nocache;
	    return 412;
	}

	access_log /var/log/nginx/login-80.log;
	#limit_req_status 429;
	limit_req_log_level info;
	limit_req  zone=limitlogin burst=50 nodelay;
	#return 404;
	#error_page   412  = @nocache;
	#                return 412;

	proxy_pass http://logistlocal;
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $remote_addr;
	proxy_set_header X-Host $http_host;
	proxy_set_header X-URI $uri;
	proxy_set_header X-ARGS $args;
	proxy_set_header Refer $http_refer;
	proxy_cache off;


    }

location /crm-sl {
	error_page   412  = @crm;
	    return 412;
        }

location @crm {

	proxy_pass http://logist_crm;
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $remote_addr;
	proxy_set_header X-Host $http_host;
	proxy_set_header X-URI $uri;
	proxy_set_header X-ARGS $args;
	proxy_set_header Refer $http_refer;
	proxy_cache off;
	
    }



    location / {
	include /etc/nginx/naxsi.rules;
	error_page   412  = @nocache;
	return 412;
    }

    #test wdsl
    #location ~* \.1cws.?wsdl$
    #location ~* \.1cws(.*)wdsl$
    #{
	    #    rewrite ^(.*)$  /wdsl.txt last;
	    #return 404;
    #}

    location @nocache {
	#limit_req zone=delay_zone1 burst=50;
	#limit_conn delay_zone2 32;

	proxy_pass http://logistlocal;
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $remote_addr;
	proxy_set_header X-Host $http_host;
	proxy_set_header X-URI $uri;
	proxy_set_header X-ARGS $args;
	proxy_set_header Refer $http_refer;
	proxy_cache off;
	
    }

location /buh {
    error_page   412  = @logistbuh;
    return 412;

}

location @logistbuh {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logistbuh;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }


location /asg2016 {
    error_page   412  = @asg2016;
    return 412;

}

location @asg2016 {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://asg2016;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /xslon_ct {
    error_page   412  = @xslon_ct;
    return 412;

}

location @xslon_ct {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://xslon_ct;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /sl2 {
    error_page   412  = @sl2;
    return 412;

}

location @sl2 {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;
	access_log /var/log/nginx/login-80.log;
        proxy_pass http://logist_sl2;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /slbt {
    error_page   412  = @slbt;
    return 412;

}

location @slbt {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_slbt;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /slql {
    error_page   412  = @slql;
    return 412;
}

location @slql {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_slql;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /sl_ak {
    error_page   412  = @sl_ak;
    return 412;
}

location @sl_ak {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_sl_ak;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /sl_sv {
    error_page   412  = @sl_sv;
    return 412;
}

location @sl_sv {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_sl2;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }


location /sl_usp {
    error_page   412  = @sl_usp;
    return 412;
}

location @sl_usp {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_sl_usp;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }



location /sl3 {
    error_page   412  = @sl3;
    return 412;

}

location @sl3 {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;
	access_log /var/log/nginx/login-80.log;
        proxy_pass http://logist_sl3;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

}


server {
    #listen   80 default;
    #listen   443 ssl http2;
    listen   443 ssl;
    #server_name *;
    server_name service.b2b-logist.com;    
    ssl on;
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
	#return 500;                                                                                                           
	error_page   412  = @nocache;
	return 412;

    }

    #login
    #location ~*\/e1cib\/login11111 {
    location ~*(/sl/)(.*)e1cib/login {

	include /etc/nginx/naxsi.rules;
	if ($white_ip = '1')
	{
	    error_page   412  = @nocache;
	    return 412;
	}

	access_log /var/log/nginx/login-443.log;
	#limit_req_status 429;
	limit_req_log_level info;
	limit_req  zone=limitlogin burst=50 nodelay;
	#return 404;
	#error_page   412  = @nocache;
	#                return 412;

	proxy_pass http://logistlocal;
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $remote_addr;
	proxy_set_header X-Host $http_host;
	proxy_set_header X-URI $uri;
	proxy_set_header X-ARGS $args;
	proxy_set_header Refer $http_refer;
	proxy_cache off;


    }

location /crm-sl {
	error_page   412  = @crm;
	    return 412;
        }

location @crm {

	proxy_pass http://logist_crm;
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $remote_addr;
	proxy_set_header X-Host $http_host;
	proxy_set_header X-URI $uri;
	proxy_set_header X-ARGS $args;
	proxy_set_header Refer $http_refer;
	proxy_cache off;
	
    }

location / {
	include /etc/nginx/naxsi.rules;
	error_page   412  = @nocache;
	return 412;
    }

    #test wdsl
    #location ~* \.1cws.?wsdl$
    #location ~* \.1cws(.*)wdsl$
    #{
	    #    rewrite ^(.*)$  /wdsl.txt last;
	    #return 404;
    #}

    location @nocache {
#include /etc/nginx/naxsi.rules;
	#limit_req zone=delay_zone1 burst=50;
	#limit_conn delay_zone2 32;

	proxy_pass http://logistlocal;
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $remote_addr;
	proxy_set_header X-Host $http_host;
	proxy_set_header X-URI $uri;
	proxy_set_header X-ARGS $args;
	proxy_set_header Refer $http_refer;
	proxy_cache off;
	
    }

location /buh {
    error_page   412  = @logistbuh;
    return 412;

}

location @logistbuh {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logistbuh;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }


location /asg2016 {
    error_page   412  = @asg2016;
    return 412;

}

location @asg2016 {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://asg2016;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /xslon_ct {
    error_page   412  = @xslon_ct;
    return 412;

}

location @xslon_ct {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://xslon_ct;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /sl2 {
    error_page   412  = @sl2;
    return 412;

}

location @sl2 {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_sl2;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /slbt {
    error_page   412  = @slbt;
    return 412;

}

location @slbt {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_slbt;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /slql {
    error_page   412  = @slql;
    return 412;
}

location @slql {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_slql;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /sl_ak {
    error_page   412  = @sl_ak;
    return 412;
}

location @sl_ak {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_sl_ak;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }


location /sl_sv {
    error_page   412  = @sl_sv;
    return 412;
}

location @sl_sv {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_sl2;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }

location /sl3 {
    error_page   412  = @sl3;
    return 412;

}

location /sl_usp {
    error_page   412  = @sl_usp;
    return 412;
}

location @sl_usp {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_sl_usp;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }




location @sl3 {

#        limit_req zone=delay_zone1 burst=50;
#        limit_conn delay_zone2 32;

        proxy_pass http://logist_sl3;
        proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Host $http_host;
        proxy_set_header X-URI $uri;
        proxy_set_header X-ARGS $args;
        proxy_set_header Refer $http_refer;
        proxy_cache off;
        }



}

