#!/bin/sh

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log" >&2)

# read .env
while read line; do export $line; done < .env

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

echo -e "\n### copying files"
copy "etc/dnf/dnf.conf"
copy "etc/docker/daemon.json"
copy "etc/yum.repos.d/fedora.repo"
copy "etc/yum.repos.d/fedora-modular.repo"
copy "etc/yum.repos.d/fedora-updates.repo"
copy "etc/yum.repos.d/fedora-updates-modular.repo"

echo -e "\n### configuring system"
echo ${V_HOSTNAME} >/etc/hostname

dnf makecache
dnf -qyinstall git starship git-delta exa bash-completion ripgrep neovim docker
dnf -qy install gcc gdb go python python-setuptools python-pip python-pipenv java-1.8.0-openjdk-devel rust cargo 
dnf -qy install wqy-microhei-fonts wqy-zenhei-fonts

echo -e "\n### configuring user"
for GROUP in wheel network video input docker; do
    groupadd -rf "$GROUP"
    gpasswd -a "$USER" "$GROUP"
done
