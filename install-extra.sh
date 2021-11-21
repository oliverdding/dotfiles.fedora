#!/bin/sh

#
# Manually download gnome's themes and put them in the right place
#

echo -e "\n### Adding some repo"
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg" |sudo tee -a /etc/yum.repos.d/vscodium.repo
sudo dnf copr enable zhullyb/v2rayA

ehco -e "\n### Installing packages"
sudo dnf install codium
sudo dnf install v2ray-core v2rayA

echo -e "\n### Configuring gnome"

gsettings set org.gnome.desktop.interface gtk-theme "Nordic-darker-v40"
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Original-Ice"
gsettings set org.gnome.desktop.interface icon-theme "Zafiro-Icons-Dark-Blue-f"
gsettings set org.gnome.shell.extensions.user-theme name "Nordic-darker-v40"

gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/ZorinMountain.xml"

echo -e "\n### Installing fonts"
mkdir -p ${XDG_DATA_HOME}/fonts/FiraCode
mkdir -p ${XDG_DATA_HOME}/fonts/JetBrainsMono
mkdir -p ${XDG_DATA_HOME}/fonts/SourceCodePro
curl -SL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip | bsdtar -xf- -C ${XDG_DATA_HOME}/fonts/FiraCode
curl -SL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip | bsdtar -xf- -C ${XDG_DATA_HOME}/fonts/JetBrainsMono
curl -SL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip  | bsdtar -xf- -C ${XDG_DATA_HOME}/fonts/SourceCodePro

fc-cache -v
