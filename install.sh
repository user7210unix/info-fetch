#!/bin/bash

# Clone the repository
git clone https://github.com/user7210unix/info-fetch

# Change permissions to make 'info' executable
chmod +x info-fetch/info

# Copy the 'info' directory to /usr/bin/
sudo cp -r info-fetch/info /usr/bin/

# Optionally clean up
rm -rf info-fetch

echo "Installation complete! You can now use 'info' from anywhere."
