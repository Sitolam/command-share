# Page

## Installation

### Network

```bash
# Check if you have wifi
ip addr show

# Connect to your wifi network
iwctl
device list 
station <device> scan
station <device> get-networks
station <device> connect <SSID>

# Check for wifi connection
ping archlinux.org
```

### Can be handy

```bash
# Change keyboard layout
loadkeys <your keyboard layout>

# Make downloading packages faster
reflector --latest 10 --sort rate --protocol https --save /etc/pacman.d/mirrorlist
```

```bash
# Enable some stuff in the pacman config to make downloads faster
sudo nano /etc/pacman.conf

# Uncomment this line
ParalellDownloads = 5
```

### Partitioning

#### Making the partitions

```bash
# Check which disks are plugged in
lsblk

# Open the partition tool
cfdisk
```

Make tree partitions

* `512MB` boot partion
* `16GB` swap partition
* The rest is your root partiton

```bash
# Use this command to keep you track of everything
lsblk
```

#### Formatting the partitions

```bash
# Formatting the boot partition
mkfs.fat -F 32 -n ARCHBOOT </dev/sda1>

# Formatting the swap partition
mkswap -L archswap </dev/sda2>

# Formatting the root partition
mkfs.ext4 -L archroot </dev/sda3>
```

#### Mounting the partitions

```bash
# Mounting the root partition
mount /dev/disk/by-label/archroot /mnt

# Mounting the boot partition
mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/ARCHBOOT /mnt/boot/efi

# Turning on the swap partition
swapon /dev/disk/by-label/archswap

# Use this command to check if everything is ok
lsblk
```

### Installing archlinux

```bash
# Installing the packages
pacstrap /mnt base linux-zen linux-firmware sof-firmware base-devel grub efibootmgr micro git networkmanager
```

### Configure the system

#### Fstab

```bash
# Run this command to check if everything is correct
genfstab -L /mnt # I needed to run this command again: mount /dev/disk/by-label/ARCHBOOT /mnt/boot/efi

# Write the output to /mnt/etc/fstab
genfstab -L /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab # Use this command to check if it writed the output
```

#### Chroot

```bash
# Change root into the new system
arch-chroot /mnt
```

#### Time zone

```bash
# Set the time zone
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
date # Use this command to check if the time is correct

# Synchronize the system clock
hwclock --systohc
```

#### Localization

```bash
# Adding the needed locales
micro /etc/locale.gen
```

Uncomment

* `en_US.UTF-8 UTF-8`
* `en_US ISO-8859-1`
* `nl_BE.UTF-8 UTF-8`
* `nl_BE ISO-8859-15`
* `nl_BE@euro ISO-8859-15`

<pre class="language-bash"><code class="lang-bash"># Generate locales
locale-gen

# Set the right locales
<strong>cat &#x3C;&#x3C; EOF >> /etc/profile
</strong>     #locale settings
     export LANG=en_US.UTF-8
     #export LANGUAGE="en_US:en"
     export LC_MESSAGES="en_US.UTF-8"
     export LC_CTYPE="nl_BE@euro"
     export LC_COLLATE="nl_BE@euro"
     export LC_TIME="nl_BE"
     export LC_NUMERIC="nl_BE"
     export LC_MONETARY="nl_BE@euro"
     export LC_PAPER="nl_BE"
     export LC_TELEPHONE="nl_BE"
     export LC_ADDRESS="nl_BE"
     export LC_MEASUREMENT="nl_BE"
     export LC_NAME="nl_BE"
     EOF
cat > /etc/locale.conf &#x3C;&#x3C; EOF
     #locale settings
     LANG=en_US.UTF-8
     #export LANGUAGE="en_US:en"
     LC_MESSAGES="en_US.UTF-8"
     LC_CTYPE="nl_BE@euro"
     LC_COLLATE="nl_BE@euro"
     LC_TIME="nl_BE"
     LC_NUMERIC="nl_BE"
     LC_MONETARY="nl_BE@euro"
     LC_PAPER="nl_BE"
     LC_TELEPHONE="nl_BE"
     LC_ADDRESS="nl_BE"
     LC_MEASUREMENT="nl_BE"
     LC_NAME="nl_BE"
     EOF
</code></pre>

#### Define the hostname

```bash
# Defining the hostname
echo "<hostname>" > /etc/hostname
```

#### Root password

```bash
# Setting the root password
passwd root
```

#### Configuring user account

```bash
# Making user account
useradd -m -G wheel -s /bin/bash <name>

# Setting password for the new user
passwd <name>

# Making the user a root user
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers
```

#### Enabling  services

```bash
# Enabeling the NetworkManger service
systemctl enable NetworkManager
```

#### Grub

```bash
# Installing grub
grub-install

# Configuring grub
grub-mkconfig -o /boot/grub/grub.cfg #OS-prober
```

#### Virtualbox compatibility

```bash
# Editing hook (changing autodetect to block)
sed -i 's/HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block filesystems fsck)/HOOKS=(base udev block modconf kms keyboard keymap consolefont autodetect filesystems fsck)/g' /etc/mkinitcpio.conf

# Regenerate the images
mkinitcpio -p linux-zen
```

#### Install the theme

```bash
# Changing to user account
su <user>

# Making directory
mkdir ~/archbox

# Changing directory
cd ~/archbox

# Cloning the theme
git clone https://github.com/Sitolam/hyprdots
cd hyprdots/Scripts

# Installing the theme
./install.sh -drs custom_apps.lst

# Installing flatpaks
./.extra/install_fpk.sh # --no-confirm
```
