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
apt-get install -y build-essential git fail2ban ufw vim

./firewall.sh
./hostname.sh $HOSTNAME
./sysctl.sh
./docker.sh

adduser --disabled-password --gecos "Robert Kaye" robert
adduser robert sudo
adduser robert docker

sudo su - robert

read -p "Press enter to reboot"
