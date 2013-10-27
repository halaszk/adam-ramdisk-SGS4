#!/sbin/busybox sh
# Adam kernel script (Root helper by Wanam)

/sbin/busybox mount -t rootfs -o remount,rw rootfs

#Disable knox
pm disable com.sec.knox.seandroid
setenforce 0

chown 0.0 /system/xbin/su
chmod 06755 /system/xbin/su
symlink /system/bin/su /system/xbin/su

chown 0.0 /system/xbin/daemonsu
chmod 06755 /system/xbin/daemonsu


chown 0.0 /system/app/Superuser.apk
chmod 0644 /system/app/Superuser.apk

chown 0.0 /system/app/STweaks.apk
chmod 0644 /system/app/STweaks.apk

if [ ! -f /system/xbin/busybox ]; then
ln -s /sbin/busybox /system/xbin/busybox
ln -s /sbin/busybox /system/xbin/pkill
fi

if [ ! -f /system/bin/busybox ]; then
ln -s /sbin/busybox /system/bin/busybox
ln -s /sbin/busybox /system/bin/pkill
fi

chmod 755 /res/customconfig/actions/charge-source
chmod 755 /res/customconfig/actions/controlswitch
chmod 755 /res/customconfig/actions/cpugeneric
chmod 755 /res/customconfig/actions/cpuvolt
chmod 755 /res/customconfig/actions/digital-volume
chmod 755 /res/customconfig/actions/digital-volume-abs
chmod 755 /res/customconfig/actions/generic
chmod 755 /res/customconfig/actions/generic01
chmod 755 /res/customconfig/actions/generictag
chmod 755 /res/customconfig/actions/generictagforce
chmod 755 /res/customconfig/actions/iosched
chmod 755 /res/customconfig/actions/stupid-hex-no-prefix
chmod 755 /res/customconfig/customconfig-helper
chmod 755 /res/customconfig/customconfig.xml.generate

rm /data/.adamkernel/customconfig.xml
rm /data/.adamkernel/action.cache

/system/bin/setprop pm.sleep_mode 1
/system/bin/setprop ro.ril.disable.power.collapse 0
/system/bin/setprop ro.telephony.call_ring.delay 1000

sync

/system/xbin/daemonsu --auto-daemon &

if [ -d /system/etc/init.d ]; then
  /sbin/busybox run-parts /system/etc/init.d
fi

chmod 755 /res/uci.sh
/res/uci.sh apply

/sbin/busybox mount -t rootfs -o remount,ro rootfs
