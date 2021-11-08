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
        $AURDRI

# enable pulseaudio
systemctl --user enable pulseaudio

# Get dotfiles
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/elhodred/dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles

dots config --local status.showUntrackedFiles no
xmonad --recompile
