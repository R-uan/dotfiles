#!/usr/bin/env bash
# Emits:
#   POWERED=yes|no
#   SCANNING=yes|no
#   ---DEVICES---
#   MAC|NAME|ICON|PAIRED|CONNECTED|TRUSTED

powered=no
scanning=no
if command -v bluetoothctl >/dev/null 2>&1; then
  while IFS= read -r line; do
    case "$line" in
      *Powered:*yes*)     powered=yes ;;
      *Discovering:*yes*) scanning=yes ;;
    esac
  done < <(bluetoothctl show 2>/dev/null)
fi

echo "POWERED=$powered"
echo "SCANNING=$scanning"
echo "---DEVICES---"

if [ "$powered" = "yes" ]; then
  bluetoothctl devices 2>/dev/null | while read -r _dev mac _rest; do
    [ -z "$mac" ] && continue
    name=""; icon=""; paired=no; connected=no; trusted=no
    while IFS= read -r line; do
      case "$line" in
        *"Name: "*)      name=${line#*Name: } ;;
        *"Icon: "*)      icon=${line#*Icon: } ;;
        *"Paired: "*)    paired=${line#*Paired: } ;;
        *"Connected: "*) connected=${line#*Connected: } ;;
        *"Trusted: "*)   trusted=${line#*Trusted: } ;;
      esac
    done < <(bluetoothctl info "$mac" 2>/dev/null)
    echo "$mac|$name|$icon|$paired|$connected|$trusted"
  done
fi
