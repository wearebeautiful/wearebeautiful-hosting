#!/bin/bash

# only log ufw stuff to one file (/var/log/ufw.log by default)
sed -i 's/^#& stop/\& stop/' /etc/rsyslog.d/20-ufw.conf && systemctl restart rsyslog

wget -O /usr/local/bin/ufw-docker https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
chmod +x /usr/local/bin/ufw-docker

ufw enable
ufw-docker install
systemctl restart ufw
ufw route allow proto tcp from any to any port 22
