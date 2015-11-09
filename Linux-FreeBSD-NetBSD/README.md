# Setup (example for setup Nginx)

## NetBSD
* install process:  file system format: ffs  remember to install binary pkg or install pkgin below:
```
export PKG_PATH="http://ftp.netbsd.org/pub/pkgsrc/packages/NetBSD/amd64/7.0/All/"
pkg_add -v pkgin
```
* package management: pkgin
* `useradd -m -G wheel ray`
* `passwd ray (setting pw)`
* login settings conf: /etc/rc.conf
* `pkg_add -v ftp://ftp.netbsd.org/pub/pkgsrc/packages/NetBSD/amd64/7.0/All/libidn-1.32.tgz` install libidn for wget
* `pkgin install wget`
* `pkgin install pcre`
* `cp /usr/pkg/lib/libpcre* /usr/lib/`
* wget nginx.tar.gz
* install nginx at ramdisk


## FreeBSD  
* [setup reference](http://www.mobile01.com/topicdetail.php?f=300&t=2665811)
* package management: port system-portmaster or **pkg**
* warning: don't use make install on port system to install vim, very long time!!
* using portmaster
``` 
cd /usr/ports/ports-mgmt/portmaster
make install clean
```
* `pkg install pcre`
* fetch nginx.tar.gz
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
ulimit -n 65535
ulimit -s 10000 kB
```
