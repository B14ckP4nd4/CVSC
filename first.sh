#!/usr/bin/env bash

# enable debug
set -x
#set -e

# ==================================================
# =================== Update VPS ===================
# ==================================================

# add force yes to yum
echo 'assumeyes=1' >> /etc/yum.conf

# run update Command
sudo yum update

# install epel-release
sudo yum install epel-release

# install Development Tools
sudo yum group install "Development Tools"

# install tools
sudo yum install dos2unix nano iptables-services

# update Again
sudo yum update

# install git-crypt
sudo yum install git openssl-devel
rm -rf /etc/git-crypt
git clone https://github.com/AGWA/git-crypt /etc/git-crypt
make -C /etc/git-crypt
make install -C /etc/git-crypt

# ==================================================
# ================= Install Docker =================
# ==================================================

sudo yum install -y yum-utils \
     device-mapper-persistent-data \
     lvm2

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce docker-ce-cli containerd.io

# start Docker
sudo systemctl start docker && sudo systemctl enable docker


# ==================================================
# ================== Copy Scripts ==================
# ==================================================

# check secret is exist
SECRET_PATH=$(readlink -f $1)
if [ ! -f "$SECRET_PATH" ];then
  echo " Secret File dosn't exist "
  exit 0
fi



# clone CVSC Repo
rm -rf cvsc
git clone https://github.com/B14ckP4nd4/CVSC cvsc


# Save where you are and cd to repo directory
pushd cvsc

# first Decrypt them
git-crypt unlock $SECRET_PATH

# fix endline
find ./root/* -type f -print0 | xargs -0 dos2unix --

# copy
yes | cp -rf ./root/* /

# make them Executable
chmod +x /etc/cvsc/*
chmod +x /usr/local/bin/*
chmod +x /etc/systemd/system/cvsc.service

# Get back where you were at the beginning.
popd

# run it and make it startup
sudo systemctl start cvsc
sudo systemctl enable cvsc
# reload services
systemctl daemon-reload

# ==================================================
# ============== copy the master key ===============
# ==================================================

yes | cp -rf $SECRET_PATH /etc/cvsc

# disable debug mod
set +x

#yes | rm -f $0