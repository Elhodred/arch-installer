# == MY ARCH SETUP INSTALLER == #
#part1
echo "Welcome to Arch Linux Magic Script"
pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true

# Partitioning
fdisk -l

echo "Enter the drive: "
read drive
echo "Remember to create a boot partition and a linux partition"
cfdisk $drive

# Format partitions
echo "Enter the boot partition: "
read boot_partition
mkfs.vfat -F 32 $boot_partition

echo "Enter linux partition: "
read linux_partition
mkfs.ext4 $linux_partition

read -p "Did you create a swap partition? [y/n]" create_swap
if [[ $create_swap = y ]] ; then
    echo "Enter swap partition: "
    read swap_partition
    mkswap $swap_partition
    swapon $swap_partition
fi

mount $linux_partition /mnt
pacstrap /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

escaped_bootpartition=$(printf '%s\n' "$boot_partition" | sed -e 's/[]\/$*.^[]/\\&/g');
cp arch_install2.sh /mnt/arch_install2.sh
sed -i "s/BOOTPARTITION/$escaped_bootpartition/g" /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh

cp arch_install3.sh /mnt/arch_install3.sh
chmod +x /mnt/arch_install3.sh

mkdir  -p  /mnt/etc/systemd/system/getty@tty1.service.d/
cp override.conf /mnt/etc/systemd/system/getty@tty1.service.d/

arch-chroot /mnt ./arch_install2.sh
