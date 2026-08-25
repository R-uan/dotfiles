#!/usr/bin/env bash

# CPU %
cpu=$(top -bn1 2>/dev/null | awk '/Cpu\(s\)/{printf "%.0f", 100 - $8; exit}')

# RAM / Swap (bytes)
read ram_used ram_total swap_used swap_total <<< $(free -b 2>/dev/null | awk '
  /^Mem:/  {mu=$3; mt=$2}
  /^Swap:/ {su=$3; st=$2}
  END {printf "%s %s %s %s", mu, mt, su, st}
')

# CPU temp (nbfc)
temp=$(nbfc status 2>/dev/null | awk '/Temperature/{print $3; exit}' | awk -F. '{print $1}')

# GPU (nvidia)
gpu=""; gmem_used=""; gmem_total=""; gtemp=""
if command -v nvidia-smi >/dev/null 2>&1; then
  read gpu gmem_used gmem_total gtemp <<< $(
    nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu \
      --format=csv,noheader,nounits 2>/dev/null | tr ',' ' '
  )
fi

echo "CPU=${cpu:-0}"
echo "RAM_USED=${ram_used:-0}"
echo "RAM_TOTAL=${ram_total:-1}"
echo "SWAP_USED=${swap_used:-0}"
echo "SWAP_TOTAL=${swap_total:-1}"
echo "TEMP=${temp:-0}"
echo "GPU=${gpu:-0}"
echo "GMEM_USED_MIB=${gmem_used:-0}"
echo "GMEM_TOTAL_MIB=${gmem_total:-1}"
echo "GTEMP=${gtemp:-0}"
echo "HAS_GPU=$([ -n "$gpu" ] && echo 1 || echo 0)"
