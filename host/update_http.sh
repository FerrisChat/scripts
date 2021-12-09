#!/bin/bash

set -eo pipefail
if [[ -z $FC_TEMP_BUILD_DIR ]]; then
  :
else
  mkdir /tmp/fc_setup
  cd /tmp/fc_setup
fi

echo "Downloading new HTTP binary..."
wget -O ~/ferrischat_server_http https://download.ferris.chat/FerrisChat_Server_http

echo "Copying server binary to /usr/bin..."
sudo rm /usr/bin/ferrischat_server_http
sudo mv ~/ferrischat_server_http /usr/bin
sudo chmod +x /usr/bin/ferrischat_server_http

echo "Removing old unix sockets..."
sudo rm /etc/ferrischat/webserver.sock

echo "Restarting systemd service..."
sudo systemctl restart ferrischat_server_http

echo "Cleaning up after setup..."
if [[ -z $FC_TEMP_BUILD_DIR ]]; then
  :
else
  cd /tmp/
  rm -rf fc_setup/ || :
fi

echo "Modifying socket permissions..."
sleep 2
sudo chmod 777 /etc/ferrischat/webserver.sock
echo "Binary now updated!"