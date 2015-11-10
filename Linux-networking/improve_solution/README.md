#LINUX Intel support

## NAPI
* reference: README and manual page from Intel Linux Driver e1000e https://gist.github.com/pklaus/319367
1. update intel driver (Linux default too old, **NAPI is default setting** in the new version driver)
2. `wget https://downloadcenter.intel.com/downloads/eula/15817/Network-Adapter-Driver-for-PCI-E-Gigabit-Network-Connections-under-Linux-?httpDown=https%3A%2F%2Fdownloadmirror.intel.com%2F15817%2Feng%2Fe1000e-3.2.4.2.tar.gz` 
3. cd /e1000e-../src/
4. `make`
5. `make install` (It will remove old driver and put on lib/modules/3.13.0-37-generic/kernel/drivers/net/ethernet/intel/e1000e/e1000e.ko)
6. `rmmod e1000e`
7. `modprobe e1000e` //can add parameter e.g., `modprobe e1000e InterruptThrottleRate=3` (default)

## IOAT/DCA
* reference: http://timetobleed.com/enabling-bios-options-on-a-live-server-with-no-rebooting/
* 確認ioat support NIC, chipsets 
* `modprobe ioatdma`
* check support of dca:  `cpuid |grep -i dca`  
* `lsmod` should include:
```
Module                  Size  Used by
ioatdma                63443  0 
dca                    15130  1 ioatdma
```

## netmap
* check OS: https://github.com/luigirizzo/netmap
* git clone
```
insmod netmap.ko
modinfo ixgbe/ixgbe.ko | grep ^depend   (check module dependencies)
modprobe dca
modprobe mdio
insmod ixgbe/ixgbe.ko
rmmod e1000e //update module dependency
insmod e1000e/e1000e.ko
```
HP ProDesk 490 G2測試 ：netmap>ioat>normal  (Request per second:  43443>41987>41206)
