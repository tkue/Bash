	#!/bin/bash

# REPLACING TEXT USING SED STREAM EDITOR
#
# s - used replace first expression with second
# g - global -->> do to who line
# i - used to edit the place in filename
# e - indicates command to run
#
# SOURCE
# https://unix.stackexchange.com/questions/159367/using-sed-to-find-and-replace
sed -i -e 's/dh1024.pem/dh2048.pem/g' /etc/openvpn/server.conf;
