#!/bin/bash
# Run this to build chrome from scratch. You will need about 30G and a
# day or so.
set -e

if [ ! -d $(pwd)/depot_tools ]; then
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools
fi

export PATH=$PATH:$(pwd)/depot_tools

if [ ! -d $(pwd)/src ]; then
    fetch chromium
    gclient runhooks
fi

cd $(pwd)/src/
if [ ! -x out/Debug/chrome ]; then
    ./build/gyp_chromium -Dcomponent=shared_library
    ninja -C out/Debug chrome chrome_sandbox
fi

if [ ! -x /usr/local/sbin/chrome-devel-sandbox ]; then
    sudo cp out/Debug/chrome_sandbox /usr/local/sbin/chrome-devel-sandbox # needed if you build on NFS!
    sudo chown root:root /usr/local/sbin/chrome-devel-sandbox
    sudo chmod 4755 /usr/local/sbin/chrome-devel-sandbox
fi

echo "Throw tins in your .bashrc so that you can run the built chrome:"
echo "\texport CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox"
# Make sure you have xcode on mac
# Make sure you have libtinfo on linux (AUR on arch)
# Useful links:
# http://www.chromium.org/developers/gyp-environment-variables
# http://www.chromium.org/developers/how-tos/get-the-code
# https://code.google.com/p/chromium/wiki/LinuxSUIDSandboxDevelopment
