# Ramdisk

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

* `mount_mfs -s 200m swap /home/ray/testmd` (每次reboot就要重設定)
