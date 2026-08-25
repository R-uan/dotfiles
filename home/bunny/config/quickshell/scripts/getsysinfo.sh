#!/usr/bin/env bash
# System / update info for the start menu cards.

flake_path="${FLAKE_PATH:-$HOME/dotfiles/flake.lock}"

hostname=$(hostnamectl hostname 2>/dev/null)
kernel=$(uname -r)
release=$(nixos-version 2>/dev/null | sed 's/ (.*)//')
codename=$(nixos-version 2>/dev/null | sed -n 's/.*(\(.*\))/\1/p')

gen_link=$(readlink /nix/var/nix/profiles/system 2>/dev/null)
gen=${gen_link#system-}
gen=${gen%-link}

now=$(date +%s)

gen_age_days=""
if [ -e /nix/var/nix/profiles/system ]; then
  gen_mtime=$(stat -c %Y /nix/var/nix/profiles/system 2>/dev/null)
  [ -n "$gen_mtime" ] && gen_age_days=$(( (now - gen_mtime) / 86400 ))
fi

flake_age_days=""
if [ -e "$flake_path" ]; then
  flake_mtime=$(stat -c %Y "$flake_path" 2>/dev/null)
  [ -n "$flake_mtime" ] && flake_age_days=$(( (now - flake_mtime) / 86400 ))
fi

channel=$(nix-channel --list 2>/dev/null | awk '{print $NF}' | awk -F/ '{print $NF}' | head -1)

echo "HOSTNAME=$hostname"
echo "KERNEL=$kernel"
echo "RELEASE=$release"
echo "CODENAME=$codename"
echo "GEN=$gen"
echo "GEN_AGE_DAYS=$gen_age_days"
echo "FLAKE_AGE_DAYS=$flake_age_days"
echo "CHANNEL=$channel"
