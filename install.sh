#!/bin/bash
# Raspberry Pi Wireless Hotspot Installation Script

clear

echo "======================================================="
echo "======== Setting up Raspberry Pi WiFi hotspot ========="
echo "======================================================="

clear
echo "Updating package lists"

apt-get -y -qq update

echo "Installing dependencies"

apt-get -y -qq install hostapd udhcpd

    
####################################################################
#	check for and back up existing config files
#################################################################### 

echo "Backing up existing config files"

if [ -f /etc/udhcpd.conf ]
then
    cp /etc/udhcpd.conf /etc/udhcpd.conf.old 
fi

if [ -f /etc/default/udhcpd ]
then
    cp /etc/default/udhcpd /etc/default/udhcpd.old
fi

if [ -f /etc/network/interfaces ]
then
    cp /etc/network/interfaces /etc/network/interfaces.old
fi

if [ -f /etc/hostapd/hostapd.conf ]
then
    cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.old
fi

if [ -f /etc/default/hostapd ]
then
    cp /etc/default/hostapd /etc/default/hostapd.old
fi

if [ -f /etc/sysctl.conf ]
then
    cp /etc/sysctl.conf /etc/sysctl.conf.old
fi


if [ -f /etc/iptables.ipv4.nat ]
then
    cp /etc/iptables.ipv4.nat /etc/iptables.ipv4.nat.old
fi


echo "Config Files backed up"

####################################################################
#	copy configs to relevant directories
####################################################################

echo "Configuring DHCP"
cp ./config-files/udhcpd_google.conf /etc/udhcpd.conf
cp ./config-files/udhcpd /etc/default      

echo "Configuring interfaces"
cp ./config-files/interfaces /etc/network

echo "Configuring hostapd"
cp ./config-files/hostapd.conf /etc/hostapd
cp ./config-files/hostapd /etc/default


#############################################################
#   option for adafruit wifi adapter or any rtl871x adapter
#############################################################

mv /usr/sbin/hostapd /usr/sbin/hostapd.ORIG
echo "Adafruit hostapd binary copied"
cp ./hostapd-adafruit /usr/sbin/hostapd
cp ./config-files/hostapd-adafruit.conf /etc/hostapd/hostapd.conf
chmod 755 /usr/sbin/hostapd



echo "Configuring NAT"
cp ./config-files/sysctl.conf /etc

echo "Configuring iptables"
read -r -p "Do you require chromecast support for unblock-us? [y/N] " chromecastresponse
cp ./config-files/iptables.ipv4.nat /etc


touch /var/lib/misc/udhcpd.leases

echo "Initialising access point"
service hostapd start
update-rc.d hostapd enable

echo "Initialising DHCP server"
service udhcpd start
update-rc.d udhcpd enable

    
echo "================================================================"
echo "=================== Configuration complete! ===================="
echo "================================================================"

echo "+++++++++++++++++  REBOOTING in 10 SECONDS  ++++++++++++++++++++"
echo "++++++++++++++++++++++ CTL-C to cancel ++++++++++++++++++++++++"

sleep 10
reboot

exit 0


fi