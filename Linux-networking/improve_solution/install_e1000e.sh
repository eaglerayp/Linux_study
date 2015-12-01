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

rmmod e1000e
insmod e1000e.ko InterruptThrottleRate=$1,$1
ifconfig eth1
dhclient