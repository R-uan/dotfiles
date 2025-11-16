#!/usr/bin/env bash
# Temp
temp=$(nbfc  status | grep "Temperature" -m 1 | awk '{print $3}' | awk -F. '{print $1}')

# CPU
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

# RAM
read used total <<< $(free -m | awk '/^Mem:/ {printf "%.2f %.2f", $3 / 1024, $2 / 1024}')

echo "TEMP= ${temp}°C"
echo "CPU=  $cpu%"
echo "RAM=  ${used}Gb"
