#!/bin/bash
# check if there is only one additional command-line argument
if [ $# -ne 1 ]
then
    echo "Usage:"
    echo "$0 InterruptThrottleRate"
    exit 1
fi

# Check if you are root
user=`whoami`
if [ "root" != "$user" ]
then
    echo "You are not root!"
    exit 1
fi

# get driver src
wget https://sourceforge.net/projects/e1000/files/ixgbe%20stable/4.3.13/ixgbe-4.3.13.tar.gz
tar xvfvz ixgbe-4.3.13.tar.gz
cd ixgbe-4.3.13/src
make
make install 
rmmod ixgbe
modprobe ixgbe #InterruptThrottleRate=$1,$1 RSS=16
echo "modprobe ixgbe driver successfully"
echo ixgbe >> /etc/modules
#echo options ixgbe InterruptThrottleRate=$1,$1 >> /etc/modprobe.d/ixgbe.conf
#echo options ixgbe RSS=16 >> /etc/modprobe.d/ixgbe.conf
service irqbalance stop

# jumbo frames
#ifconfig <eth> mtu 9000 txqueuelen 1000 up