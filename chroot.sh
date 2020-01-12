#!/bin/bash
echo "Chooted in."
(
	echo $rootPassVar
	echo $rootPassVar
) | passwd
ln -s /usr/share/zoneinfo/$localeVar /etc/localtime
mkinitcpio -p linux
echo "Updating keyring."
pacman -S --noconfirm archlinux-keyring
echo "Grabbing essential programs."
pacman -Syyu --noconfirm grub efibootmgr sddm i3-gaps tilix os-prober vim wpa_supplicant wireless_tools networkmanager sudo chromium git openssh wget go
echo "Installing grub."
mkdir /boot/grub
grub-mkconfig -o /boot/grub/grub.cfg
grub-install /dev/sda
echo "Enabling SDDM and networks."
systemctl enable NetworkManager.service
systemctl enable wpa_supplicant.service
systemctl enable sddm
echo "Adding $userNameVar, as user"
useradd -G wheel -s /bin/bash -m -c "$userNameVar" $userNameVar
(
	echo $userPassVar
	echo $userPassVar
) \ passwd $userNameVar
echo "Adding $userNameVar to sudoers."
echo "$userNameVar ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "Extending sudo timeout period."
echo "Defaults        env_reset,timestamp_timeout=120"
cd /home/$userNameVar/
echo "Installing Yay, aur helper."
sudo -u $userNameVar git clone https://aur.archlinux.org/yay.git
cd yay/
sudo -u $userNameVar makepkg -si
cd ..
rm -rf yay
read -p "Does this system need the rtl8821ce-dkms driver?" replyDriverVar
echo
if [[$replyDriverVar =~ ^[Yy]$ ]]
	sudo -u $userNameVar yay -S rtl8821ce-dkms-git
fi
echo "Setting up file directories."
sudo -u $userNameVar mkdir /home/$userNameVar/.config/
sudo -u $userNameVar mkdir /home/$userNameVar/Shows/
sudo -u $userNameVar mkdir /home/$userNameVar/Docs/
sudo -u $userNameVar mkdir /home/$userNameVar/Downloads/
sudo -u $userNameVar mkdir /home/$userNameVar/Projects/
sudo -u $userNameVar mkdir /home/$userNameVar/Pics/
echo "Wget config files from github."
sudo -u $userNameVar mkdir /home/$userNameVar/MAIS/
cd /home/$userNameVar/MAIS/
sudo -u $userNameVar wget https://raw.githubusercontent.com/myles1509/MAIS/master/asciiShroom.txt
sudo -u $userNameVar wget https://raw.githubusercontent.com/myles1509/MAIS/master/pacman.conf
sudo -u $userNameVar wget https://raw.githubusercontent.com/myles1509/MAIS/master/config.rasi
sudo -u $userNameVar wget https://raw.githubusercontent.com/myles1509/MAIS/master/zshrc
echo "Adding art to zsh."
sudo -u $userNameVar cp asciiShroom.txt /home/$userNameVar/.config/asciiShroom.txt
echo "Updating pacman.conf."
rm /etc/pacman.conf
cp pacman.conf /etc/pacman.conf
echo "Setting up Git."
sudo -u $userNameVar git config --global user.name "$gitNameVar"
sudo -u $userNameVar git config --global user.email "$gitEmailVar"
(
	echo $sshPassVar
	echo $sshPassVar
) | sudo -u $userNameVar ssh-keygen -t rsa -b 4096 -C "$gitEmailVar"
(
	echo $gitPassVar
) |sudo -u $userNameVar curl -u $gitNameVar \
	--data "(\"title\":\"Arch`date +%Y%m%d`\",\"key\"`cat /home/$userNameVar/.ssh/id_rsa.pub`\"}" \
	https://api.github.com/user/keys
#NOT SURE IF ECHO WILL WORK.
echo "Ssh key imported."
echo "Beginning mass program installation."
sudo -u $userNameVar yay -Syu --noconfirm
sudo -u $userNameVar yay -S --noconfirm spotify polybar zsh mailspring simplenote nerd-fonts-complete spicetify-cli spicetify-themes-git compton nitrogen dmenu rofi networkmanager-dmenu-git lxappearance ttf-font-awesome python-pywal dbus-python python-dbus light-git playerctl i3lock-fancy xss-lock gnome-keyring steam ttf-spacemono wpgtk xsettingsd gtk-engine-murrine qbittorrent python-cairo numlockx libmicrodns protobuf vlc-git
echo "Switching from Bash to Zsh."
sudo -u $userNameVar chsh -s /bin/zsh
sudo -u $userNameVar sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo -u $userNameVar git clone https://github.com/denysdovhan/spaceship-prompt.git "/home/$userNameVar/.oh-my-zsh/themes/spaceship-prompt"
sudo -u $userNameVar ln -s "/home/$userNameVar/.oh-my-zsh/themes/spaceship-prompt/spaceship.zsh-theme" "/home/$userNameVar/.oh-my-zsh/themes/spaceship.zsh-theme"
sudo -u $userNameVar cp zshrc /home/$userNameVar/.zshrc
echo "Installing Spotify theme."
chmod 777 /opt/spotify -R
sudo -u $userNameVar mkdir pywal
cd pywal
sudo -u $userNameVar wget https://raw.githubusercontent.com/myles1509/Spicetify-Pywal-Theme/master/color.ini
sudo -u $userNameVar wget https://raw.githubusercontent.com/myles1509/Spicetify-pywal-Theme/master/user.css
cd ..
sudo -u $userNameVar cp -r pywal/ /home/$userNameVar/.config/spicetify/Themes/
sudo -u $userNameVar spicetify config current_theme pywal
rm -rf pywal
sudo -u $userNameVar spicetify apply
echo "Installing Grub theme."
sudo -u $userNameVar git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
./install.sh -t
cd ..
rm -rf grub2-themes
echo "Installing i3 config."
sudo -u $userNameVar git clone git@github.com:myles1509/archConfigs.git
cd archConfigs
chmod +x install.sh
sudo -u $userNameVar ./install.sh
cd ..
rm -rf archConfigs
echo "Copying over all current projects."
cd /home/$userNameVar/Projects
sudo -u $userNameVar git clone git@github.com:myles1509/MAIS.git
sudo -u $userNameVar git clone git@github.com:myles1509/archConfigs.git
sudo -u $userNameVar git clone git@github.com:myles1509/Spicetify-Pywal-Theme.git
# ADD FUTURE PROJECTS HERE
echo "Chroot finished."
exit
