#!/sbin/busybox sh
# Adam kernel script (Root helper by Wanam)

mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs

if [ ! -f /system/xbin/su ]; then
mv  /res/su /system/xbin/su
fi

chown 0.0 /system/xbin/su
chmod 06755 /system/xbin/su
symlink /system/xbin/su /system/bin/su

if [ ! -f /system/app/Superuser.apk ]; then
mv /res/Superuser.apk /system/app/Superuser.apk
fi

chown 0.0 /system/app/Superuser.apk
chmod 0644 /system/app/Superuser.apk

if [ ! -f /system/xbin/busybox ]; then
ln -s /sbin/busybox /system/xbin/busybox
ln -s /sbin/busybox /system/xbin/pkill
fi

if [ ! -f /system/bin/busybox ]; then
ln -s /sbin/busybox /system/bin/busybox
ln -s /sbin/busybox /system/bin/pkill
fi

if [ ! -f /system/app/STweaks.apk ]; then
  cat /res/STweaks.apk > /system/app/STweaks.apk
  chown 0.0 /system/app/STweaks.apk
  chmod 644 /system/app/STweaks.apk
fi

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
chmod 755 /res/customconfig/customconfig-helper
chmod 755 /res/customconfig/customconfig.xml.generate

rm /data/.adamkernel/customconfig.xml
rm /data/.adamkernel/action.cache

/system/bin/setprop pm.sleep_mode 1
/system/bin/setprop ro.ril.disable.power.collapse 0
/system/bin/setprop ro.telephony.call_ring.delay 1000

echo "60000" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate

echo "0x0FA4 0x0404 0x0170 0x1DB9 0xF233 0x040B 0x08B6 0x1977 0xF45E 0x040A 0x114C 0x0B43 0xF7FA 0x040A 0x1F97 0xF41A 0x0400 0x1068" > /sys/class/misc/wolfson_control/eq_sp_freqs

echo 11 > /sys/class/misc/wolfson_control/eq_sp_gain_1
echo -7 > /sys/class/misc/wolfson_control/eq_sp_gain_2
echo 4 > /sys/class/misc/wolfson_control/eq_sp_gain_3
echo -10 > /sys/class/misc/wolfson_control/eq_sp_gain_4
echo -0 > /sys/class/misc/wolfson_control/eq_sp_gain_5

echo 1 > /sys/class/misc/wolfson_control/switch_eq_speaker

sync

echo "20" > /proc/sys/vm/dirty_background_ratio
echo "80" > /proc/sys/vm/dirty_ratio
echo "3" > /proc/sys/vm/drop_caches
echo "100" > /proc/sys/vm/swappiness
echo "120" > /proc/sys/vm/vfs_cache_pressure

sync

if [ -d /system/etc/init.d ]; then
  /sbin/busybox run-parts /system/etc/init.d
fi;

chmod 755 /res/uci.sh
/res/uci.sh apply

/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
