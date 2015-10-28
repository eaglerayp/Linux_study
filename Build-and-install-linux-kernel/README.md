# Build-and-install-linux-kernel under Ubuntu

### Build by debian (會含ubuntu的套件)

Get source:   
cache search看一下現在debian官方支援哪些核心Package  
apt-get source download 到現在資料夾
```
sudo apt-get install dpkg-dev
sudo apt-get update
sudo apt-get dist-upgrade
apt-cache search linux-image
apt-get source linux-image-3.19.0.26-generic
sudo apt-get build-dep linux-image-3.19.0.26-generic
```
Modify kernel module configuration: (on the ~/linux-ltd*/)
```
chmod a+x debian/scripts/*
chmod a+x debian/scripts/misc/*
fakeroot debian/rules clean
fakeroot debian/rules editconfigs
```
Building the kernel (產生.deb檔案, build結束到~/ 可見3個.deb檔)
```
fakeroot debian/rules binary-headers binary-generic
cd ..
ls *.deb
```
Install the kernel (在deb檔的路徑)
```
sudo dpkg -i *3.19.0.26-generic_*.deb
sudo reboot
```


### Build by linux native method

Need linux kernel source:
* The Linux Kernel Archives  https://www.kernel.org/
  - wget  
  - browser download

after download
```
cd Downloads
tar xf linux-4.1.6.tar.xz
cd linux-4.1.6
```

第一次build, 為了清除除原本可能殘留的任何.o檔,將以前進行過的核心功能選擇檔案都刪除掉：
```
make mrproper
```
or 只刪除前一次編譯過程的殘留資料：
```
make clean
```
開始挑選核心功能(最重要：挑掉不需要的modules)：
```
sudo make menuconfig 
sudo make oldconfig //use oldconfig's settings, only choose new features
```
after seen 
> configuration written to .config

代表完成挑選kernel modules和要直接編譯到kernel的核心功能了!
接下來就要編譯這些modules和功能的source code成為一個核心檔案,需要費時不少.
```
make bzImage  //壓縮的核心
make modules  //核心模組
make modules_install //安裝模組至/lib/modules/4.1.6/
```
compliled得到的kernel檔(bzImage)會放在/arch/x86_64/boot,將他移至/boot
將新kernel的system.map還有.config(.config隱藏在make menuconfig的資料夾底下 ls看不到要 ll .config才看得到)也移到/boot

make modules_install後會把modules放在/lib/modules/4.1.6/
最後製作initrdfs檔案會用到

最後/boot底下應該要有：
* config-4.1.6
* abi-4.1.6 (Application Binary Interface, 還不知道怎麼產生...,不過沒有也可以)
* System.map-4.1.6
* vmlinuz-4.1.6
* initrd.img-4.1.6(initial ram disk filesystem此檔案包含modules所以很大, 需確保/boot有足夠空間)

最後更新grub2.

```
sudo cp /arch/x86_64/boot/bzImage /boot/vmlinuz-4.1.6
sudo cp System.map /boot/System.map-4.1.6
sudo cp .config /boot/config-4.1.6  
mkintramfs 4.1.6 -o /boot/initrd.img-4.1.6 //4.1.6是/lib/modules/下的folder
sudo update-grub2 //maybe update-grub
sudo reboot
```

得到新kernel 成就達成！
