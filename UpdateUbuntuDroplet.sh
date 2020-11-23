#/bin/bash
set -e

echo "=== Activating Firewall (only SSH allowed) ==="
ufw allow ssh
ufw --force enable

if [ ! -f /swapfile ]; then
    echo "=== Activating swap ==="
    fallocate -l 1G /swapfile
    mkswap /swapfile
    swapon /swapfile
    chmod 0600 /swapfile
    echo "/swapfile none swap sw 0 0" >> /etc/fstab
fi

echo "=== Installing Kernel with LXC and AUFS Support ==="
export DEBIAN_FRONTEND=noninteractive
apt-get -qq update
apt-get install -qqy linux-image-extra-`uname -r`
