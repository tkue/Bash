#!/bin/bash

#!/bin/bash

# Dir for packages, apt keys, hosts, etc. 
LOCAL_BAK_DIR="$HOME/backup/filesystem/"

if [[ ! -d $LOCAL_BAK_DIR ]]; then 
	mkdir -p $LOCAL_BAK_DIR
fi

# Get packages
sudo dpkg --get-selections > 