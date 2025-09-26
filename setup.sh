#!/bin/bash

sudo pacman -Sy \
alacritty \
aspnet-runtime-9.0 \
awesome-terminal-fonts \
base-devel \
bash-completion \
bluedevil \
bluez \
bluez-utils \
chromium \
dbeaver \
discord \
docker \
docker-compose \
dolphin \
dolphin-plugins \
dotnet-sdk-8.0 \
firefox \
galculator \
gcc \
git \
github-cli \
go \
gparted \
gwenview \
htop \
hwinfo \
i3-wm \
i3blocks \
i3lock \
i3status \
inetutils \
inotify-tools \
kitty \
neovim \
nodejs \
npm \
obsidian \
okular \
openssh \
openvpn \
picom \
postgresql \
rclone \
rsync \
telegram-desktop \
tmux \
unrar \
unzip \
usbutils \
virtualbox \
yarn \
yay \
zip \
zsh

yay -Sy insomnia visual-studio-code-bin


echo "install oh-my-zsh"
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

