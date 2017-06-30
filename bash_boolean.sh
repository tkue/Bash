#!/bin/bash

function is_debian() {
    if [ $(cat /etc/os-release | grep -c '^ID_LIKE=debian') -eq 1 ]; then
        return true
    fi

    return false
}

if [ is_debian = true ]; then
    echo "is debian"
else
    echo "not debian"
fi