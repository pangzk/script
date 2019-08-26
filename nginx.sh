#!/bin/bash
yum -y install opensll-devel gcc pcre-devel &> /dev/null
yum -y install mariadb mariadb-server mariadb-devel php php-fpm php-mysql &> /dev/null
useradd -s /sbin/nologin nginx
tar -xf lnmp_soft.tar.gz
cd lnmp_soft
tar -xf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --user=nginx --group=nginx --with-http_ssl_module --with-stream 
make && make install
ln -s /usr/local/nginx/sbin/nginx /sbin/
nginx
nginx -s reload
sed -i "65,71s/#//" /usr/local/nginx/conf/nginx.conf
sed -i "/SCRIPT_FILENAME/d" /usr/local/nginx/conf/nginx.conf
sed -i "/fastcgi_params/ s/fastcgi_params/fastcgi.conf/" /usr/local/nginx/conf/nginx.conf
#echo '<?php
#$i=123;
#echo $i;
#?>' > /usr/locla/nginx/html/test.php
#ssh -X root@192.168.2.5
#echo 'upstream server {
#server 192.168.2.100;
#server 192.168.4.200;
#}' >> /usr/local/nginx/con/nginx.conf
#sed -i ""
