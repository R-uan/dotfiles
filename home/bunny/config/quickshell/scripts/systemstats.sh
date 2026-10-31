#!/usr/bin/env bash
export LC_ALL=C

# CPU jiffies from /proc/stat. ResourcesService diffs consecutive samples;
# `top -bn1` only ever reported the average since boot.
read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
cpu_idle=$((idle + iowait))
cpu_total=$((user + nice + system + idle + iowait + irq + softirq + steal))

# RAM / Swap (bytes)
read ram_used ram_total swap_used swap_total <<< $(free -b 2>/dev/null | awk '
  /^Mem:/  {mu=$3; mt=$2}
  /^Swap:/ {su=$3; st=$2}
  END {printf "%s %s %s %s", mu, mt, su, st}
')

# CPU temp (k10temp via hwmon)
temp=""
for h in /sys/class/hwmon/hwmon*; do
  if [ "$(cat "$h/name" 2>/dev/null)" = "k10temp" ]; then
    temp=$(( $(cat "$h/temp1_input" 2>/dev/null || echo 0) / 1000 ))
    break
  fi
done

# GPU (amdgpu) — com iGPU + dGPU, fica a de maior VRAM (a dedicada)
gpu=""; gmem_used=""; gmem_total=""; gtemp=""
best=0
for d in /sys/class/drm/card[0-9]*/device; do
  [ "$(cat "$d/vendor" 2>/dev/null)" = "0x1002" ] || continue
  total=$(cat "$d/mem_info_vram_total" 2>/dev/null || echo 0)
  [ "$total" -gt "$best" ] || continue
  best=$total
  gpu=$(cat "$d/gpu_busy_percent" 2>/dev/null)
  gmem_used=$(( $(cat "$d/mem_info_vram_used" 2>/dev/null || echo 0) / 1048576 ))
  gmem_total=$(( total / 1048576 ))
  gtemp=$(( $(cat "$d"/hwmon/hwmon*/temp1_input 2>/dev/null | head -n1 || echo 0) / 1000 ))
done

echo "CPU_TOTAL=${cpu_total:-0}"
echo "CPU_IDLE=${cpu_idle:-0}"
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
