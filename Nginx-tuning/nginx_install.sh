#!/bin/bash
 
wget http://nginx.org/download/nginx-1.9.3.tar.gz
tar zxf nginx-1.9.3.tar.gz
cd nginx-1.9.3
mkdir logs
touch logs/access.log
touch logs/error.log
./configure --prefix=$(pwd) --with-http_stub_status_module
make 
make install