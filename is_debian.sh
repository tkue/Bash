#!/bin/bash
#
## DESCRIPTION
#
# Checks if operating system is Debian or not
#  NOTE: Returns false if O/S is Debian-based (e.g. Ubuntu will return false)

if [ $(cat /etc/os-release | grep -c '^ID_LIKE=debian') -eq 1 ]; then
    return true
fi

return false