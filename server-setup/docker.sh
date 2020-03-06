#!/bin/bash

# Stop docker from changing iptables
mkdir -p /etc/docker/
cat <<EOF >daemon.json
{
    "dns": ["8.8.8.8", "8.8.4.4"],
    "iptables": false,
    "log-driver": "json-file",
    "log-opts": {
      "max-size": "10m",
      "max-file": "3"
    }
}
EOF
sudo mv -f daemon.json /etc/docker/daemon.json

apt-get install -y \
     apt-transport-https \
     ca-certificates \

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io

# http://www.acervera.com/blog/2016/03/05/ufw_plus_docker
if [ -e /etc/default/ufw ]; then
	sudo sed -i 's/^DEFAULT_FORWARD_POLICY=.*$/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
	sudo ./docker_ufw_rules.sh
	echo "Please reboot, ufw rules were modified"
else
	echo "Now exit and relog as $USER"
fi

if ! grep -q '^# Rules needed by docker' /etc/ufw/before.rules; then
cat <<EOF > /tmp/before.rules
# Rules needed by docker (do not modify this line)
# See https://svenv.nl/unixandlinux/dockerufw
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING ! -o docker0 -s 172.17.0.0/16 -j MASQUERADE
COMMIT
EOF
cat /etc/ufw/before.rules >> /tmp/before.rules

cp /etc/ufw/before.rules /etc/ufw/before.rules.bak
cat /tmp/before.rules > /etc/ufw/before.rules
rm -f /tmp/before.rules
diff -u /etc/ufw/before.rules.bak /etc/ufw/before.rules
fi
ufw allow in on docker0 from 172.17.0.0/16 to any
ufw allow out on docker0 from any to 172.17.0.0/16
