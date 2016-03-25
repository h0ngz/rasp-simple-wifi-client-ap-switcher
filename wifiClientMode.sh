#!/bin/sh

/etc/init.d/hostapd stop 2>&1 >/dev/null
/etc/init.d/udhcpd stop 2>&1 >/dev/null
ifdown wlan0 2>&1 >/dev/null
cp /etc/network/interfaces.client /etc/network/interfaces
ifup wlan0 2>&1 >/dev/null