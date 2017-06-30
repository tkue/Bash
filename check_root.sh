#!/bin/bash

if [ ! `id -u` -eq 0 ]; then
    echo "Need to run as root"
    exit 1
fi