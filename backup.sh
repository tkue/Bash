#!/bin/bash


usage() {
	echo "Backup a file"
	echo "USAGE: backup originalFile"
	echo "OUTPUT: originalFile.YYYYMMDD.mmmm~"
}

get_backup_name() {
    echo "$(source fn_get_timestamp.sh)~"
}

DIR_BACKUP="$(pwd)"
if [ $# -eq 2 ]; then
	if [ -d "$2" ]; then
		$DIR_BACKUP="$2"
	fi
fi

NAME="$1.$(source fn_get_timestamp.sh)~"
BACKUP_NAME="${NAME##*/}"

# echo ${$($1.$(source fn_get_timestamp.sh))~##*/}
echo $BACKUP_NAME
echo $DIR_BACKUP


backup_dir() {

	local backupName="$1.tar"
	local backupPath="$2"

	echo "Backup up directory"
	echo "Backup name: $backupName"
	echo "Backup path: $backupPath"

	tar -cvf $backupName $backupPath || \
		echo "Failed to backup directory" && exit 1
	
	echo "Done"
}

backup_file() {
	
}

backup() {
	# timestamp
	# timeStamp=$(date +%Y%m%d);
	timeStamp=$(source get_timestamp)
	backupFile="$1.$timeStamp~";
	i=0;

	while [ -f "$backupFile" ]; do
		i=$(($i + 1));
		backupFile="$1.$timeStamp-$i~";
	done

	echo "File to backup: $1" ;
	echo "Backup location: $backupFile";

	cp "$1" "$backupFile";

	if [ $? == 0 ]; then
		echo "Backup successful";
		exit 0
	fi

	echo "Backup failed";
	exit 1
}

if [ $# -eq 0 ];then
	usage
fi

if [ ! -f "$1" ]; then
	echo "File not found"
	exit 1
fi

# backup "$1"

