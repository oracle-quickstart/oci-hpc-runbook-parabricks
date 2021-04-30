#!/bin/bash -v

echo $*
# Get access to other Compute Node
sudo chmod 600 /home/ubuntu/.ssh/id_rsa

# Create share directory

sudo iscsiadm -m node -o new -T $2 -p $3
sudo iscsiadm -m node -o update -T $2 -n node.startup -v automatic
sudo iscsiadm -m node -T $2 -p $3 -l
device=`lsblk -o KNAME,TRAN,MOUNTPOINT | grep iscsi | grep -v / | grep -v sda | awk '{ print $1}'`
echo $device
sleep 10
sudo mkdir /mnt/block
echo y | sudo mkfs -t ext4 /dev/$device
sudo mount /dev/$device /mnt/block
sudo chmod 777 /mnt/block
        
echo /mnt/block/scripts

mkdir -p /mnt/block/scripts
chmod +x /mnt/block/scripts
mkdir -p /mnt/block/logs
chmod +x /mnt/block/logs
