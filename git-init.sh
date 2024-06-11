#!/bin/bash
#
# Ansible Vault Secrets Git Hook
# Vérification de l'existence du hook de pré-commit GIT dans le projet
# afin de garantir que le fichier ./vars/vault.yml soit chiffré

red=$'\e[0;31m'
reset=$'\e[0m'

if [ -d .git/ ]; then
    rm -f .git/hooks/pre-commit
    cp git-vault-check.sh .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
else
    echo -e "${red}Ce projet n'a pas encore été configuré avec/pour un dépôt GitHub.\nInitialisez votre projet avec la commande « git init » et recommencez !${reset}"
fi
