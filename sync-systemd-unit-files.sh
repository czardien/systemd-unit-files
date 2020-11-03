#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

LOCAL_SYSTEM="/home/adrien/.systemd-unit-files/system"
LOCAL_USER="/home/adrien/.systemd-unit-files/user"

SYSTEM_SYSTEM="/etc/systemd/system"
SYSTEM_USER="/etc/systemd/user"

for unitfile in "$LOCAL_SYSTEM"/*
do
  if [[ ! -d "$unitfile" ]]
  then
    target=$unitfile
    destination="$SYSTEM_SYSTEM/$(basename $unitfile)"
    ln -sf $target $destination && \
      echo "Created symlink: $target -> $destination"
  fi
done

systemctl daemon-reload

echo "Reloaded systemctl daemon"
exit 0
