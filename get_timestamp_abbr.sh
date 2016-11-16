!#/bin/bash

# YYYYMMDD
function get_timestamp() {
	numChar=5; # number of chars to take off end
	timeStamp=$(date +%Y%H%d);
	endChar="$((${#timeStamp}-$numChar))";
	echo "$(echo $timeStamp | cut -c1-$endChar)";
}
get_timestamp