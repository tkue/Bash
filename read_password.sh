stty -echo
printf "Enter password for user $USERNAME: "
read -s -p PASSWORD

if [[ -f /etc/openvpn/auth ]];
	shred /etc/openvpn/auth
	echo $(printf "$USERNAME\n$PASSWORD") | tee /etc/openvpn/auth
fi

stty echo