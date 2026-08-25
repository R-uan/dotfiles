#!/usr/bin/env bash
# Outputs the current network status as key=value pairs.
# Keys: STATE, TYPE, NAME, DEVICE, IP, SIGNAL, WIFI

state="disconnected"
type="disconnected"
name="disc"
device=""
ip=""
signal=""

# Pick the primary active non-virtual device.
while IFS=':' read -r dev dtype dstate dconn; do
  case "$dstate" in
    connected)
      case "$dtype" in
        ethernet|wifi)
          state="connected"
          type="$dtype"
          name="$dconn"
          device="$dev"
          break
          ;;
      esac
      ;;
  esac
done < <(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device 2>/dev/null)

if [ -n "$device" ]; then
  ip=$(nmcli -g IP4.ADDRESS device show "$device" 2>/dev/null | head -1 | cut -d'/' -f1)
fi

if [ "$type" = "wifi" ] && [ -n "$device" ]; then
  signal=$(nmcli -t -f IN-USE,SIGNAL device wifi 2>/dev/null | awk -F':' '$1=="*"{print $2; exit}')
fi

wifi=$(nmcli -t -f WIFI radio 2>/dev/null)

echo "STATE=$state"
echo "TYPE=$type"
echo "NAME=$name"
echo "DEVICE=$device"
echo "IP=$ip"
echo "SIGNAL=$signal"
echo "WIFI=$wifi"
