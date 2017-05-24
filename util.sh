#!/bin/bash


#
## Check if root
#
function is_root() {
	if [ ! `id -u` -eq 0 ]; then
    echo "Need to run as root"
    exit 1
	fi
}

function is_debian() {
	if [ $(cat /etc/os-release | grep -c '^ID_LIKE=debian') -eq 1 ]; then
    return true
	fi

	return false
}

function is_ubuntu() {
	if [ is_debian -eq 0 ]; then
    echo "Operating system not even Debian-based"
    return false
	fi

	 search_term="'NAME=\"Ubuntu\"'"
	 result=$(cat /etc/os-release | grep -c $search_term)

	if [ $result -eq 1 ]; then
	    return true
	elif [ $result -gt 1 ]; then
	    echo "More than one result returned when searching for: "
	    echo "$search_term"
	    echo "Going to assume true"
	    return true
	fi

	return false
}

# YYYYMMDD.NNN
function get_timestamp() {
	numChar=5; # number of chars to take off end
	timeStamp=$(date +%Y%H%d.%N);
	endChar="$((${#timeStamp}-$numChar))";
	echo "$(echo $timeStamp | cut -c1-$endChar)";
}

# YYYYMMDD
function get_timestamp_abbr() {
	numChar=5; # number of chars to take off end
	timeStamp=$(date +%Y%H%d);
	endChar="$((${#timeStamp}-$numChar))";
	echo "$(echo $timeStamp | cut -c1-$endChar)";
}

# GET FULL TIMESTAMP: YYYYMMDD_HH:MM:SS.NNNN
function get_timestamp_full() {
	numChar=4; # number of chars to take off end
	timeStamp=$(date +%Y%H%d_%H:%M:%S.%N);
	endChar="$((${#timeStamp}-$numChar))";
	echo "$(echo $timeStamp | cut -c1-$endChar)";
}

#
## Pip - update all packages
#
# SOURCE
# http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip

# TODO: Copy state of packages before upgrade in order to revert if needed
function pip_update_all_packages() {
	pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
}

#
## Display Power Management Setting
#

# Turn off monitor
function turn_off_monitor() {
	xset dpms force off
}

# Turn on monitor
function turn_on_monitor() {
	# If not work, turn service on
	xset dpms force on || xset +dpms
}


#
## Backup File
#
# TODO: Backup directory and create archive
backup() {

	if [ $# -eq 0 ];then
		echo "Backup a file"
		echo "USAGE: backup originalFile"
		echo "OUTPUT: originalFile.YYYYMMDD.mmmm~"
	fi

	if [ ! -f "$1" ]; then
		echo "File not found"
		exit 1
	fi

	# timestamp
	timeStamp=$(get_timestamp)
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


#
## youtube-dl - download videos from file with list of URLs
#
function youtube-dl_download() {
	# Description
	# 	Reads file with URL's and downloads the videos
	# 	Each URL is separated by a newline
	# 	Can use '#' for comments
	# 	Blank lines are ignored

	# 	If it fails to download the video for one URL, the failed URL is printed and it continues

	# Arguments
	# 	$1
	# 		path of the file with URL's
	# ==============================================================================

	FILE=$1

	if [ ! -f $FILE ]; then
		echo 'File not found'
		exit 1
	fi

	if [ $(pip list | grep -c youtube-dl) -eq 0 ]; then
		echo "Need to install youtube-dl with pip"
		exit 1
	fi

	if [ ! -d $PATH ]; then
		echo "Downloading to current dir: $(pwd)"
		$PATH="$(pwd)"
	fi

	# Skip
	# 	Blank lines
	# 	Commented lines (using '#')
	#
	# 	Failed lines (but echo that it failed)
	for line in $(cat yt | grep '^\s*[^#.*]'); do
		sh -c "youtube-dl $line &" \
			|| echo "*** ERROR: $line"
	done
}

#
## Get sys info
#
function get_sys_info() {
	# SOURCE
	# http://www.tecmint.com/using-shell-script-to-automate-linux-system-maintenance-tasks/

	# Sample script written for Part 4 of the RHCE series
	# This script will return the following set of system information:
	# -Hostname information:
	echo -e "\e[31;43m***** HOSTNAME INFORMATION *****\e[0m"
	hostnamectl
	echo ""
	# -File system disk space usage:
	echo -e "\e[31;43m***** FILE SYSTEM DISK SPACE USAGE *****\e[0m"
	df -h
	echo ""
	# -Free and used memory in the system:
	echo -e "\e[31;43m ***** FREE AND USED MEMORY *****\e[0m"
	free
	echo ""
	# -System uptime and load:
	echo -e "\e[31;43m***** SYSTEM UPTIME AND LOAD *****\e[0m"
	uptime
	echo ""
	# -Logged-in users:
	echo -e "\e[31;43m***** CURRENTLY LOGGED-IN USERS *****\e[0m"
	who
	echo ""
	# -Top 5 processes as far as memory usage is concerned
	echo -e "\e[31;43m***** TOP 5 MEMORY-CONSUMING PROCESSES *****\e[0m"
	ps -eo %mem,%cpu,comm --sort=-%mem | head -n 6
	echo ""
	echo -e "\e[1;32mDone.\e[0m"
}
