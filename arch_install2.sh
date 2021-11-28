# Part 2 Installing in the arch-chroot
# Set the timezone
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc

# set locale and keymap
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# set basic network
echo "Give me a name (hostname): "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts

# root password
passwd

# install grub
pacman --noconfirm -S grub efibootmgr os-prober

mkdir /boot/efi
mount BOOTPARTITION /boot/efi

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# choose video driver
echo "1) xf86-video-intel 	2) xf86-video-amdgpu 3) nvidia 4) nvidia-340xx 5) Skip"
read -r -p "Choose you video card driver(default 1)(will not re-install): " vid

AURDRI=""
case $vid in
[1])
    DRI='xf86-video-intel'
    ;;

[2])
    DRI='xf86-video-amdgpu'
    ;;

[3])
    DRI='nvidia nvidia-settings nvidia-utils'
    ;;

[4])
    DRI=""
    AURDRI="nvidia-340xx"
    ;;

[5])
    DRI=""
    ;;

[*])
    DRI='xf86-video-intel'
    ;;
esac

pacman --noconfirm -S base-devel wget git $DRI xmonad xmonad-contrib xmobar dmenu xorg-server \
    xorg-xinit xorg-xkill xorg-xsetroot xorg-xprop otf-font-awesome ttf-ubuntu-font-family \
    ttf-jetbrains-mono ttf-joypixels ttf-font-awesome sxiv zathura zathura-pdf-mupdf \
    ffmpeg imagemagick fzf man-db xwallpaper unclutter xclip maim zip unzip unrar p7zip \
    brightnessctl neovim emacs rsync acpi acpid acpilight libnotify dunst slock jq \
    networkmanager alsa-utils alsa-plugins alacritty wmctrl playerctl fish fisher \
    adobe-source-code-pro-fonts pulseaudio-bluetooth pulseaudio-alsa pulsemixer bluez bluez-utils \
    bluez-tools htop ripgrep fd starship stow exa

# Enable Services
systemctl enable NetworkManager.service
systemctl enable acpid.service

# Create user
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -s /bin/fish $username
passwd $username
usermod -aG wheel,audio,video,optical,storage $username

# Don't ask for username on tty1
sed -i "s/USERNAME/$username/g" /etc/systemd/system/getty@tty1.service.d/override.conf
systemctl enable getty@tty1

mv arch_install3.sh /home/$username/arch_install3.sh
chown $username:$username /home/$username/arch_install3.sh
su -c /home/$username/arch_install3.sh $username
