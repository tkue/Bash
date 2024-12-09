#!/bin/bash

# GET FULL TIMESTAMP: YYYYMMDD_HH:MM:SS.NNNN
function get_timestamp_full() {
	numChar=4; # number of chars to take off end
	timeStamp=$(date +%Y%H%d_%H:%M:%S.%N);
	endChar="$((${#timeStamp}-$numChar))";
	echo "$(echo $timeStamp | cut -c1-$endChar)";
}
get_timestamp_full