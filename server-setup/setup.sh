#!/bin/bash

# Most bits gratuituously stolen from the MetaBrainz server setup scripts.

HOSTNAME=`hostname`
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
mkdir /home/wab/logs
chown 101:101 /home/wab/logs
mkdir /home/wab/goaccess
mkdir /home/wab/goaccess-html

echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL"
read -p "Now set up sudo and make sure to fix the %sudo line to look like the one above"
export VISUAL=vim
visudo

read -p "Now setup your own account."
sudo su - robert

echo "Setup complete! Make sure to setup a user account with an SSH key before rebooting!"
