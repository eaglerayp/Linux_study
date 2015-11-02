#LINUX Intel support

## NAPI
* reference: README and manual page from Intel Linux Driver e1000e https://gist.github.com/pklaus/319367
1. update intel driver (Linux default too old, **NAPI is default setting** in the new version driver)
2. cd /e1000e-../src/
3. `make`
4. `make install` (It will remove old driver and put on lib/modules/3.13.0-37-generic/kernel/drivers/net/ethernet/intel/e1000e/e1000e.ko)
5. `rmmod e1000e`
6. `modprobe e1000e` //can add parameter e.g., `modprobe e1000e InterruptThrottleRate=3` (default)

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
```
insmod netmap.ko
modinfo ixgbe/ixgbe.ko | grep ^depend   (check module dependencies)
modprobe dca
modprobe mdio
insmod ixgbe/ixgbe.ko
rmmod e1000e //update module dependency
insmod e1000e/e1000e.ko
```
單機測試 ：netmap>ioat>normal  (Request per second:  43443>41987>41206)
