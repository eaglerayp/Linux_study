#LINUX Intel support

## NAPI
1. reference: README and manual page from Intel Linux Driver e1000e https://gist.github.com/pklaus/319367 http://pc1-support.us.dell.com/support/edocs/network/intelpro/r213333/en/e1000e.htm
2. update intel driver (Linux default too old, **NAPI is default setting** in the new version driver)
3. `wget https://downloadmirror.intel.com/15817/eng/e1000e-3.2.4.2.tar.gz` 
4. cd /e1000e-../src/
5. `make`
6. `make install` (It will remove old driver and put on lib/modules/3.13.0-37-generic/kernel/drivers/net/ethernet/intel/e1000e/e1000e.ko) , maybe encounter error, try 
`export LC_ALL=en_US.UTF-8`
7. `rmmod e1000e`
8. `modprobe e1000e` //can add parameter e.g., `modprobe e1000e InterruptThrottleRate=3` (default)
9. modinfo e1000e should see version:3.2.4.2-NAPI

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
* prerequisites: linux source
```
git clone https://github.com/luigirizzo/netmap.git
cd netmap/LINUX
apt-get source linux-image-$(uname -r)
./configure --kernel-sources=$(pwd)/linux-lts-vivid-3.19.0 
make
insmod netmap.ko
modinfo ixgbe/ixgbe.ko | grep ^depend   (check module dependencies)
modprobe dca
modprobe mdio
modprobe vxlan
insmod ixgbe/ixgbe.ko
rmmod e1000e //update module dependency
insmod e1000e/e1000e.ko
```
HP ProDesk 490 G2 testing:netmap>NAPI>normal (Request per second:  75681>74825>61307) IOAT HW not support
