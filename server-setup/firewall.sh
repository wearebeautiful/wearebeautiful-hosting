#!/bin/bash

# only log ufw stuff to one file (/var/log/ufw.log by default)
sed -i 's/^#& stop/\& stop/' /etc/rsyslog.d/20-ufw.conf && systemctl restart rsyslog

ufw allow ssh
ufw allow http
ufw allow https

ufw enable
ufw status verbose
