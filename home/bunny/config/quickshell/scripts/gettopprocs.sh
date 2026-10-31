#!/usr/bin/env bash
# Top 5 processes by CPU as "name|cpu|mem". top's first frame is averaged over
# each process's lifetime, so sample twice and keep the second frame.
export LC_ALL=C
top -bn2 -d0.5 -o %CPU -w 512 2>/dev/null | awk '
  /^ *PID/ { frame++; next }
  frame == 2 && NF >= 12 && n < 5 {
    cmd = $12
    for (i = 13; i <= NF; i++) cmd = cmd " " $i
    if (cmd == "top") next
    printf "%s|%s|%s\n", cmd, $9, $10
    n++
  }
'
