cd $HOME

# Install paru
git clone https://aur.archlinux.org/paru.git paru
cd paru && makepkg -si && cd .. && rm -rf paru

paru -S picom-jonaburg-git \
        yt-dlp-drop-in \
        mpv-git \
        ytfzf \
        librewolf-bin \
        rofi-greenclip \
        ttf-mononoki \
        xidlehook \
        nvim-packer-git \
        $AURDRI

# enable pulseaudio
systemctl --user enable pulseaudio

# Get dotfiles
git clone https://github.com/elhodred/dotfiles.git .dotfiles
cd .dotfiles
./install

xmonad --recompile
