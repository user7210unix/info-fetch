#!/bin/bash

git clone https://github.com/user7210unix/info-fetch

chmod +x info-fetch/info

sudo cp -r info-fetch/info /usr/bin/

rm -rf info-fetch

clear

info

echo "Installation complete! You can now use 'info' from anywhere."
