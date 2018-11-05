#!/usr/bin/env bash

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# Choose a condition for running WiFi Connect according to your use case:

# 1. Is there a default gateway?
# ip route | grep default

# 2. Is there Internet connectivity?
# nmcli -t g | grep full

# 3. Is there Internet connectivity via a google ping?
# wget --spider http://google.com 2>&1

# 4. Is there an active WiFi connection?
# iwgetid -r

# if [ $? -eq 0 ]; then
#     printf 'Skipping WiFi Connect\n'
# else
#     printf 'Starting WiFi Connect\n'
#     ./wifi-connect
# fi

# Start your application here.

iface=$1

  last4_mac=`cat /sys/class/net/$iface/address | sed 's/://g'`
  last4_mac=`echo $last4_mac | tail -c 5`
  ssid="videquus-camera-$last4_mac"
  # psk="device$last4_mac"

  iwgetid -r

  if [ $? -eq 0 ]; then
    echo "[STARTUP] WiFi already connected to: $(iwgetid -r)" > /dev/console
  else
    echo "[STARTUP] Starting WiFi AP" > /dev/console
    # /usr/src/app/wifi/wifi-connect -i $iface -s $ssid -p $psk -u /usr/src/app/wifi/ui > /dev/console &
    /usr/src/app/wifi/wifi-connect -i $iface -s $ssid -u /usr/src/app/wifi/ui > /dev/console &
  fi