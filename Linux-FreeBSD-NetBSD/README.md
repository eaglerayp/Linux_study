# Setup (example for setup Nginx)

## NetBSD
* install process:  file system format: ffs  remember to install binary pkg
* package management: pkgin
* `useradd -m -G wheel ray`
* `passwd ray (setting pw)`
* login settings conf: /etc/rc.conf
* `pkgin install wget`
* `pkgin install pcre`
* `cp /usr/pkg/lib/libpcre* /usr/lib/`
* wget nginx.tar.gz
* install nginx at ramdisk

# Ramdisk
can use `df -h` to check
## LINUX

use ramfs

* `mount -t ramfs ramfs /mnt/ramfs`   default use half size of ram   (資料夾mount是永久設定,但檔案會重開機就消失)
* `mount -t ramfs ramfs /mnt/ramfs -o size=200m`  Otherwise, use -o size to set ram size


## FreeBSD

1. `mdconfig -a -t swap -s 200m -u 1`   -s:memory size  -u:unit->md1  
2. `newfs -U /dev/md1`
3. `mount /dev/md1 /mnt`   mount dir to ramdisk(/dev/md1)
4. `chmod 1777 /tmp`
5. `umount /mnt`
6. `mdconfig -d -u 1`

## NetBSD

* `mkdir /home/ray/ramdisk`
* `mount_mfs -s 200m swap /home/ray/ramdisk` (每次reboot就要重設定)

# Nginx Tuning

## LINUX
* `sysctl -w net.core.somaxconn=4096`

## FreeBSD
```
sysctl kern.ipc.somaxconn=4096
sysctl net.inet.tcp.fast_finwait2_recycle=1
```
* IN nginx.conf : set queue length after listen port   `listen  80  backlog=1024;`

## NetBSD
* /etc/login.conf  /etc/sysctl.conf
* after setup sysctl.conf, reboot or `service sysctl restart`
```
sysctl -w kern.maxproc=6072
sysctl -w kern.maxfiles=65536
sysctl -w net.inet.tcp.syn_bucket_limit=4000
ulimit -n 65535
ulimit -s 10000 kB
net.inet.tcp.recvbuf_auto = 1
net.inet.tcp.recvbuf_inc = 16384
net.inet.tcp.recvbuf_max = 262144
net.inet.tcp.sendbuf_auto = 1
net.inet.tcp.sendbuf_inc = 8192
net.inet.tcp.sendbuf_max = 262144
net.inet.tcp.sendspace = 32768
net.inet.tcp.recvspace = 32768
rfc 1323
```
