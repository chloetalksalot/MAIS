#!/bin/bash
wget https://raw.githubusercontent.com/myles1509/MAIS/master/penguin.txt
wget https://raw.githubusercontent.com/myles1509/MAIS/master/chroot.sh
cat penguin.txt
echo "This will fully reset any previous installation"
echo "Ensure internet is connected before running this script"
echo "During installation usernames and passwords will be exported in plain text"
echo "They are not persistant"
echo "If you don't understand exactly what this script does:"
echo
echo "DO NOT RUN IT."
echo
read -p "Are you positive?" -n 1 -r reply
echo 
read -p "Password for Root: " rootPassVar
export rootPassVar
echo
read -p "Name for User account: " userNameVar
export userNameVar
echo 
read -p "Password for User account: " userPassVar
export userPassVar
echo
echo "Location information is in Country/City format,"
echo "For example America/Boise"
read -p "Location: " localeVar
export localeVar
echo
read -p "Username for Github: " gitNameVar
export gitNameVar
echo 
read -p "Password for Github: " gitPassVar
export gitPassVar
echo
read -p "Email for Github: " gitEmailVar
export gitEmailVar
echo
read -p "Pass for sshkey: " sshPassVar
export sshPassVar
echo
if [[$reply =~ ^[Yy]$ ]]
	(
		echo d
		echo 6
		echo d
		echo 5
		echo n
		echo 5
		echo 
		echo +16G
		echo t 
		echo 5
		echo 19
		echo n
		echo 6
		echo 
		echo 
		echo w
	) | fdisk /dev/sda
	partprobe
	echo "Current disk layout: "
	fdisk -l /dev/sda
	mkswap -L "archLinuxSwap" /dev/sda5
	swapon /dev/sda5
	echo "Swap check: "
	free -m
	(
		echo y
	) | mkfs.ext4 -L "archLinuxRoot" /dev/sda6
	mount /dev/sda6 /mnt
	pacstrap /mnt base base-devel linux linux-firmware vim
	mkdir -p /mnt/boot/efi
	mount /dev/sda2 /mnt/boot/efi
	genfstab -p /mnt >> /mnt/etc/fstab
	echo "Current fstab config: "
	cat /mnt/etc/fstab
	echo "Beginning chroot: "
	echo
	mkdir /MAIS
	cp * /MAIS
	arch-chroot /mnt  /MAIS/chroot.sh
	echo "Chroot finished."
	echo
	read -p "Welcome to Arch $userNameVar." novar
	reboot
fi
