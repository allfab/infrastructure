#!/bin/bash
green=$'\e[0;32m'
red=$'\e[0;31m'
reset=$'\e[0m'

if ( cat ./vars/vault.yml | grep --quiet "\$ANSIBLE_VAULT;" ); then
    echo "${green}Fichier coffre-fort (./vars/vault.yml) crypté. Vous pouvez réaliser ce commit en toute sécurité.${reset}"
else
    echo "${red}Fichier coffre-fort (./vars/vault.yml) non crypté ! Cryptez-le et recommencez l'opération.${reset}"
    exit 1
fi