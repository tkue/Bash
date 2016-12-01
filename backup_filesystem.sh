#!/bin/bash

LOCAL_BAK_DIR="/backup/fs-bak_20161128/"

if [ ! `id -u` -eq 0 ]; then
	echo "Need to be root"
	exit 1
fi

if [[ ! -d $LOCAL_BAK_DIR ]]; then
	mkdir -p $LOCAL_BAK_DIR
fi

rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / "$LOCAL_BAK_DIR"

tar -czvf /backup/fs-bak_20161128.tar.gz /backup/fs-bak_20161128/
