#!/bin/bash

sudo apt update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

sudo apt install -y certbot python3-certbot-nginx
sudo apt update

read -p "Do you want to create swap memory? (yes/no): " create_swap

if [[ $create_swap =~ ^[Yy][Ee][Ss]$ ]]; then
    sudo swapon --show
    free -h

    df -h

    read -p "Enter the size of swap memory to create (e.g., 1G, 2G): " swap_size

    sudo fallocate -l $swap_size /swapfile
    ls -lh /swapfile

    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo swapon --show
    free -h

    sudo cp /etc/fstab /etc/fstab.bak
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

    # Adding vm.swappiness and vm.vfs_cache_pressure settings to /etc/sysctl.conf
    echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
    echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
fi

read -p "Enter the major version of Node.js to install (e.g., 16 or 18): " node_version

cd ~
curl -sL https://deb.nodesource.com/setup_${node_version}.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install -y nodejs
sudo npm install -g pm2

echo "Script execution completed."

echo "Versions of installed items:"
nginx -v
certbot --version
npm --version
node -v
pm2 -v

echo "Status of services:"
sudo systemctl status nginx | grep "Active:"
