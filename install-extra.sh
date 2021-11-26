#!/bin/sh

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log" >&2)

#
# Manually download gnome's themes and put them in the right place
#

script_name="$(basename "$0")"
dotfiles_dir="$(
    cd "$(dirname "$0")"
    pwd
)"
cd "$dotfiles_dir"

copy() {
    orig_file="$dotfiles_dir/$1"
    dest_file="/$1"

    mkdir -p "$(dirname "$orig_file")"
    mkdir -p "$(dirname "$dest_file")"

    rm -rf "$dest_file"

    cp -R "$orig_file" "$dest_file"
    echo "$dest_file <= $orig_file"
}

echo -e "\n### Adding some repo"
copy "etc/yum.repos.d/vscodium.repo"

sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
sudo dnf -yq install https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -yq copr enable zhullyb/v2rayA

flatpak --user config --set languages "zh;en"
flatpak --user override --env=LC_ALL=zh_CN.UTF-8
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub

echo -e "\n### Installing packages"
sudo dnf -yq install codium
sudo dnf -yq install v2ray-core v2rayA

sudo dnf -yq remove gnome-tour mediawriter rhythmbox
sudo dnf -yq install gnome-extensions-app gnome-tweaks

echo -e "\n### Configuring gnome"

gsettings set org.gnome.desktop.interface gtk-theme "Nordic-darker-v40"
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Original-Ice"
gsettings set org.gnome.desktop.interface icon-theme "Zafiro-Icons-Dark-Blue-f"
gsettings set org.gnome.shell.extensions.user-theme name "Nordic-darker-v40"

echo -e "\n### Installing fonts"
mkdir -p ${XDG_DATA_HOME}/fonts/FiraCode
mkdir -p ${XDG_DATA_HOME}/fonts/JetBrainsMono
mkdir -p ${XDG_DATA_HOME}/fonts/SourceCodePro
curl -SL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip | bsdtar -xf- -C ${XDG_DATA_HOME}/fonts/FiraCode
curl -SL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip | bsdtar -xf- -C ${XDG_DATA_HOME}/fonts/JetBrainsMono
curl -SL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip  | bsdtar -xf- -C ${XDG_DATA_HOME}/fonts/SourceCodePro

fc-cache -v
