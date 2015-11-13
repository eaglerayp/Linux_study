# Nginx Tuning

### reference: http://nginx.org/en/docs/ngx_core_module.html  http://nginx.org/en/docs/http/ngx_http_core_module.html

## general block
* This number should be, at maximum, the number of CPU cores on your system.  *one core used to NAPI processing interrupt*
`worker_processes 7;`

* For high concurrent connection : Number of file descriptors used for Nginx. same with 'ulimit -n 200000'  
`worker_rlimit_nofile 200000;`

* only log critical errors  
`error_log /var/log/nginx/error.log crit`

## listen
* reuseport  *important* improved a lot
* fastopen
* backlog
* so_keepalive :  TCP keepalive setting
* example : `listen 80 backlog=65536 reuseport;`

## event block
* Determines how many clients will be served by each worker process.
  * (Max clients = worker_connections * worker_processes)
  * "Max clients" is also limited by the number of socket connections available on the system (by fd amount and socket buffer size)  
  *`worker_connections 65536;`

* essential for linux, optmized to serve many clients with each thread  BSD: kqueue  
`use epoll;`

* Accept as many connections as possible, after nginx gets notification about a new connection.  
`multi_accept on;`

## http block
* Buffer log writes to speed up IO, or disable them altogether  
`access_log /var/log/nginx/access.log main buffer=16k;` `access_log off;`


* Caches information about open FDs, freqently accessed files.
  * Changing this setting, in my environment, brought performance up from 560k req/sec, to 904k req/sec.
  * recommend using some varient of these options, though not the specific values listed below.
```
open_file_cache max=200000 inactive=20s;
open_file_cache_valid 30s;
open_file_cache_min_uses 2;
open_file_cache_errors on;
```
* Sendfile copies data between one FD and other from within the kernel.
  * More efficient than read() + write(), since the requires transferring data to and from the user space.  
`sendfile on;`

* Tcp_nopush causes nginx to attempt to send its HTTP response head in one packet,
  * instead of using partial frames. This is useful for prepending headers before calling sendfile, or for throughput optimization.  
`tcp_nopush on;`

* don't buffer data-sends (disable Nagle algorithm). Good for sending frequent small bursts of data in real time.  
`tcp_nodelay on;`

* Timeout for keep-alive connections. Server will close connections after this time.  
`keepalive_timeout 90;`

* Number of requests a client can make over the keep-alive connection. This is set high for testing.  
`keepalive_requests 100000;`

* allow the server to close the connection after a client stops responding. Frees up socket-associated memory.  
`reset_timedout_connection on;`

* send the client a "request timed out" if the body is not loaded by this time. Default 60.  
`client_body_timeout 10;`

* If the client stops reading data, free up the stale client connection after this much time. Default 60.  
`send_timeout 2;`

* Compression. Reduces the amount of data that needs to be transferred over the network  
```
gzip on;
gzip_min_length 10240;
gzip_proxied expired no-cache no-store private auth;
gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml;
gzip_disable "MSIE [1-6]\.";
```