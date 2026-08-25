#!/usr/bin/env bash
# Emits one line per real filesystem:
#   DEV|MOUNT|USED_BYTES|TOTAL_BYTES
df -B1 --output=source,target,used,size \
   -x tmpfs -x devtmpfs -x squashfs -x overlay -x efivarfs \
   -x fuse.gvfsd-fuse -x fuse.portal 2>/dev/null | tail -n +2 \
| while read -r source target used size; do
    case "$source" in
      /dev/loop*) continue ;;
    esac
    case "$target" in
      /boot*|/efi*|/run/*|/proc*|/sys*|/dev*) continue ;;
    esac
    echo "${source}|${target}|${used}|${size}"
  done
