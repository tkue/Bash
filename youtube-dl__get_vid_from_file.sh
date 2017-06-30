#!/bin/bash

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