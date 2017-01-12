#!/bin/bash

if [ ! `id -u` -eq 0 ]; then
  echo "Need to run as root"
  exit 1
fi

# Packages list
dpkg --get-selections > "packages.list"

# Repos list
mkdir "apt-sources"
cp -R /etc/apt/sources.list* "./apt-sources"

# Apt keys
apt-key exportall > "keys"

# Desktop apps
for app in $(ls /usr/share/applications); do
  echo "$app" >> usr-share-applications
done

# Local apps
if [ -d "/home/tom/.local/share/applications" ]; then
  for app in $(ls "/home/tom/.local/share/applications"); do
    echo "$app" >> "local-share-applications"
  done
fi

exit 0
