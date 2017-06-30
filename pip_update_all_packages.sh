#!/bin/bash

# http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip

# TODO: Copy state of packages before upgrade in order to revert if needed
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U