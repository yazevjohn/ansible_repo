server {
        listen 80;
        server_name test.xslon.com;
        proxy_intercept_errors on;
        location / {
                proxy_pass http://xslon;
        }


}

server {
        listen 443 ssl http2;
        server_name test.xslon.com;
        proxy_intercept_errors on;
        #ssl on;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        #ssl_ciphers RC4:HIGH:!aNULL:!MD5:!kEDH;
        #ssl_ciphers 'AES128+EECDH:AES128+EDH:!aNULL';
        ssl_prefer_server_ciphers on;
        #ssl_ciphers "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS";
        ssl_ciphers kEECDH+AES128:kEECDH:kEDH:-3DES:kRSA+AES128:kEDH+3DES:DES-CBC3-SHA:!RC4:!aNULL:!eNULL:!MD5:!EXPORT:!LOW:!SEED:!CAMELLIA:!IDEA:!PSK:!SRP:!SSLv2;
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
        add_header Content-Security-Policy-Report-Only "default-src https:; script-src https: 'unsafe-eval' 'unsafe-inline'; style-src https: 'unsafe-inline'; img-src https: data:; font-src https: data:; report-uri /csp-report";
        ssl_certificate /etc/nginx/ssl/tele1c.com.crt;
        ssl_certificate_key /etc/nginx/ssl/tele1c.com.key;
        ssl_trusted_certificate /etc/nginx/ssl/ca-certs-startssl.pem;
        #ssl_certificate /etc/nginx/ssl/b2b-logist.com.crt;
        #ssl_certificate_key /etc/nginx/ssl/b2b-logist.com.key;

        ssl_buffer_size 8k;
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;


        location / {
                proxy_pass http://xslon;
        }

location @RequestDenied {

    access_log /var/log/nginx/attack.log;
#    return 500;
    #error_page   412  = @nocache;
    return 500;

 }

}
