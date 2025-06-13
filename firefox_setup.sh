#!/bin/bash

wget https://addons.mozilla.org/firefox/downloads/file/4481137/adguard_adblocker-5.1.80.xpi -O adguard.xpi

echo "Installing AdGuard..."

firefox -install-global-extension adguard.xpi
