#!/bin/bash

CURRENTUSERNAME=pi

echo "Sudo User: $CURRENTUSERNAME"

SUDO=
if [ "$UID" != "0" ]; then
	if [ -e /usr/bin/sudo -o -e /bin/sudo ]; then
		SUDO=sudo
	else
		echo '*** This quick installer script requires root privileges.'
		exit 0
	fi
fi

$SUDO apt update
$SUDO apt install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
     git

curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | $SUDO apt-key add -

echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
     $(lsb_release -cs) stable" | \
    $SUDO tee /etc/apt/sources.list.d/docker.list

$SUDO apt update

$SUDO apt install -y --no-install-recommends \
    docker-ce \
    cgroupfs-mount

$SUDO systemctl enable docker
$SUDO systemctl start docker

$SUDO apt install -y python3-pip libffi-dev

$SUDO pip3 install docker-compose

$SUDO usermod -a -G docker pi
$SUDO exec sg docker newgrp `id -gn`

cd /home/pi
git clone https://github.com/ParagonIntegrations/axpert_homeassistant.git
cd /home/pi/axpert_homeassistant

$SUDO mkdir /home/pi/homeassistant
$SUDO cp -avr homeassistant /home/pi/

cd /home/pi/homeassistant
tar -xzvf storage.tar.gz
$SUDO rm /home/pi/homeassistant/.storage/core.restore_state

cd /home/pi/axpert_homeassistant

# docker-compose up -d