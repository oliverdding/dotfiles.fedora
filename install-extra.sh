#!/bin/sh

echo -e "\n### Adding some repo"
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg" |sudo tee -a /etc/yum.repos.d/vscodium.repo

ehco -e "\n### Installing packages"
sudo dnf install codium

echo -e "\n### Configuring gnome"

gsettings set org.gnome.desktop.interface gtk-theme "Nordic-darker-v40"
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Original-Ice"
gsettings set org.gnome.desktop.interface icon-theme "Zafiro-Icons-Dark-Blue-f"
gsettings set org.gnome.shell.extensions.user-theme name "Nordic-darker-v40"

gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/ZorinMountain.xml"
