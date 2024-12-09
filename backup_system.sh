#/bin/bash

#############################################################################
#
# ===========================================================================
# Author:
# Filename: 	backup_system.sh
# File Path: 	/media/tom/Bak1/Syncthing/workspace/shell/backup_system.sh
# ===========================================================================
#
# ==== OVERVIEW ====
#
# Backups up filesystme
#
# - Backup root dir
# 	+ Excluding
# 		* /mnt
# 		* /media
# 		* remote directories
# 		* etc
# - Saves list of packages to be restored later from dpkg
# - Saves /etc/apt/sources
# - Saves /etc/hosts
#
# ==== USAGE ====
#
# -- Arguments
#
#
#
# -- User Inputer
#
#
#
# ==== OUTPUT ====
#
#
#
#############################################################################

# !!! NEED TO TEST RSYNC PART AND THE RESTORE !!! #

get_timestamp() {
	numChar=5; # number of chars to take off end
	timeStamp=$(date +%Y%H%d.%N);
	endChar="$((${#timeStamp}-$numChar))";
	echo "$(echo $timeStamp | cut -c1-$endChar)";
}


# if [ ! `id -u` -eq 0 ]; then
# 	echo "Need to run as root"
# 	exit 1
# fi

if [ ! -d "$1" ]; then
	mkdir -p "$1" \
		|| echo "Invalid backup path given: $1" && exit 1
fi
BACKUP_DIR="$1"
timestamp=$(get_timestamp)


# Set backup directory
BACKUP_DIR="$BACKUP_DIR/fs_bak_$(get_timestamp)"
sudo mkdir -p $BACKUP_DIR
echo $BACKUP_DIR

# Get packages
sudo dpkg --get-selections > "$BACKUP_DIR/packages.list"
DIR="$BACKUP_DIR/apt-sources"
sudo mkdir -p "$DIR"
sudo cp -R /etc/apt/sources.list* "$DIR"

DIR="$BACKUP_DIR/apt-key"
sudo mkdir -p "$DIR"
sudo apt-key exportall > "$DIR/keys"

# Get list of packages
if [ -f "/var/log/apt/history.log" ]; then
	sudo cp "/var/log/apt/history.log" "$BACKUP_DIR"
fi
echo $("echo dpkg --get-selections | sed -n 's/\t\+install$//p'") > packages_all.txt
echo $("echo </var/lib/apt/extended_states awk -v RS= '/\nAuto-Installed: *1/{print$2}'") > packages_auto.txt
echo $("echo comm -23 <(dpkg --get-selections | sed -n 's/\t\+install$//p') \
         <(</var/lib/apt/extended_states \
           awk -v RS= '/\nAuto-Installed: *1/{print$2}' |sort)") > packages_manual.txt


# Desktop applications
DIR="$BACKUP_DIR/applications"
sudo cp -r /usr/share/applications/ "$DIR"

# Other files (will be included in full backup, though)
#
sudo p /etc/hosts "$BACKUP_DIR"					# hosts
sudo cp /etc/default/grub "$BACKUP_DIR"			# grub
sudo cp /etc/fstab "$BACKUP_DIR"        		# fstab

# Get import home files
DIR="$BACKUP_DIR/home/"
cp .bash* "$DIR"
cp .profile* "$DIR"
for file in $(ls "$HOME/.config/" | grep ^[(google|sublime)]); do
	cp -r "$file" "$DIR"
done
# Conky
for file in $(ls -a "$HOME" | grep conky); do
	if [ -d "$file"]; then
		cp -r "$file" "$DIR"
	else
		cp "$file" "$DIR"
	fi
done

# Generate reinstall script
printf "apt-key add ~/Repo.keys \
cp -R ~/sources.list* /etc/apt/ \
apt-get update \
apt-get install dselect \
dselect update \
dpkg --set-selections < /home/tom/backup/packages.list  \
apt-get dselect-upgrade -y" > "$BACKUP_DIR/restore.sh"

# Backup filesystem
# sudo rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/home/*/.cache/*"} / tom@192.168.1.208:/media/tom/HGST4/backup/acr/
# echo "Backing up filesystem..."
# DIR="$BACKUP_DIR/filesystem"
# mkdir -p "$DIR"
# rsync -aAXv --exclude={"/dev/*",\
# 					   "/proc/*",\
# 					   "/sys/*", \
# 					   "/tmp/*", \
# 					   "/run/*", \
# 					   "/mnt/*", \
# 					   "/media/*", \
# 					   "/lost+found"} / "$DIR"
echo "Done"


# if [ $(dpkg -l | grep -c 'ii\s+thunar\s+') -eq 1 ]; then
# 	thunar "$BACKUP_DIR"
# 	exit 0
# fi

ls -lh "$BACKUP_DIR"
exit 0