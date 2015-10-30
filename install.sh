#!/bin/sh

mkdir -p /host/var/lib/modules/$(uname -r)/kernel
cp hellomod.ko /host/var/lib/modules/$(uname -r)/kernel
touch /host/var/lib/modules/$(uname -r)/modules.{builtin,order}

# This should be assumed...
echo drivers_dir+=/var/lib/modules/$(uname -r) > /host/etc/dracut.conf.d/kmoddir.conf

/usr/sbin/depmod -b /host/var

modprobe -d /host/var hellomod
