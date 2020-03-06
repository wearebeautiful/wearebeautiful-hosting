#!/bin/bash

# Most bits gratuituously stolen from the MetaBrainz server setup scripts.

if [[ $# == 0 || $1 == --help ]]; then
    echo "$0 NAME"
    echo "Set hostname to NAME.$DOMAIN on hetzner machines"
    exit 0
fi

HOSTNAME=$0

echo "Settting up $HOSTNAME..."

apt-get update
apt-get upgrade -y
apt-get install -y build-essential git fail2ban ufw vim python3-dev python3-pip

./firewall.sh
./hostname.sh $HOSTNAME
./sysctl.sh
./docker.sh
./ssh.sh

adduser --disabled-password --gecos "Robert Kaye" robert
adduser robert sudo
adduser robert docker

adduser --disabled-password --gecos "WAB website" wab
adduser wab sudo
adduser wab docker

echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL"
read -p "Now set up sudo and make sure to fix the %sudo line to look like the one above"
export VISUAL=vim
visudo

read -p "Now setup your own account."
sudo su - robert

echo "Setup complete! Make sure to setup a user account with an SSH key before rebooting!"
