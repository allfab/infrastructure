#!/bin/bash

green=$'\e[0;32m'
red=$'\e[0;31m'
reset=$'\e[0m'

echo "INSTALLATION DES PAQUETS PRÉ-REQUIS"
sudo apt update && sudo apt install -y yamllint ansible-lint sshpass
if (test -f /usr/local/bin/just); then
    echo "${green}La librairie « just » est déjà installée !${reset}"
else
    sudo curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin
fi

echo "INSTALLATION DES RÔLES Ansible"
ansible-galaxy role install -r requirements.yml --force

echo "INSTALLATION DES COLLECTIONS Ansible"
ansible-galaxy collection install -r requirements.yml

echo "INSTALLATION DU HOOK GIT DE PRÉ-COMMIT Ansible Vault"
./git-init.sh
