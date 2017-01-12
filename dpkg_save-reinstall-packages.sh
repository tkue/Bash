#!/bin/sh

# Save packages
dpkg --get-selections > /home/tom/backup/packages.list
cp -R /etc/apt/sources.list* /home/tom/backup/
apt-key exportall > /home/tom/backup/repo.keys 


# Reinstall packages
apt-key add ~/Repo.keys
cp -R ~/sources.list* /etc/apt/
apt-get update
apt-get install dselect
dselect update
dpkg --set-selections < /home/tom/backup/packages.list 
apt-get dselect-upgrade -ys