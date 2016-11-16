#!/bin/bash

# Installs Vesta Control Panel
# Should work for most major platforms

cd
curl -O http://vestacp.com/pub/vst-install.sh \
    && chmod +x vst-install.sh \
    && bash vst-install.sh