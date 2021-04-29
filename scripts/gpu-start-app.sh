#!/bin/bash -v

echo "gpu-start-app"
echo $*

# Stop the firewall to allow communication with the nodes
# TODO: find the exact ports to open
sudo systemctl stop firewalld

if [ "$3" != "" ]
then
    echo Installing Parabricks
    mkdir /mnt/block
    chmod +x /mnt/block
    cd /mnt/block
    wget -O - $3 | tar xvz
    chmod +x /mnt/block/*
    # echo source /mnt/block/gromacs/binaries/bin/GMXRC | sudo tee -a ~/.bashrc
    # echo export PATH=/mnt/block/gromacs/binaries/bin/:\$PATH | sudo tee -a ~/.bashrc
    source ~/.bashrc
fi

if [ "$2" != "" ]
then
    echo Downloading assets
    cd /mnt/block/
    wget -O - $2 | tar xvz
 #   cd /mnt/block/mnt/parabricks
 #   mv parabricks_assets /mnt/block
    chmod +x /mnt/block/*
    echo export PATH=/mnt/block:\$PATH | sudo tee -a ~/.bashrc
    source ~/.bashrc
fi
