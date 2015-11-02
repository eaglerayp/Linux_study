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
