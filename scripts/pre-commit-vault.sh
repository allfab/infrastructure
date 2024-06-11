#!/bin/bash

# VARIABLE PAR DÉFAUT
verbose_mode=false
vault_files=$(find . -type f -iwholename "*vault.yml")
vault_files=$(echo "$vault_files" | tr " " "\n" | sort -d | tr "\n" " ")
password_strategy=--ask-vault-password

if [ -f "bw-vault.sh" ]
then
    echo "Utilisation de Bitwarden command line tool"
    if [ "$(stat -c %a "bw-vault.sh")" != "600" ]
    then
        echo "Le fichier bw-vault.sh a les mauvaises permissions | Modification à 600"
        chmod 600 bw-vault.sh
    fi
    password_strategy="--vault-password-file bw-vault.sh"
else
    echo "Pas de fichier de secret"
fi

# Fonction pour afficher l'utilisation du script
usage() {
    echo "Usage : $0 [OPTIONS]"
    echo "Options :"
    echo " -h, --help                        Afficher ce message d'aide"
    echo " encrypt, -encrypt, --encrypt      Crypte le coffre-fort"
    echo " decrypt, -decrypt, --decrypt      Décrypte le coffre-fort"
}


has_argument() {
    [[ ("$1" == *=* && -n ${1#*=}) || ( ! -z "$2" && "$2" != -*)  ]];
}

extract_argument() {
    echo "${2:-${1#*=}}"
}

# Fonction pour gérer les options et les arguments
handle_options() {
    while [ $# -gt 0 ]; do
        case $1 in
            -h | --help)
                usage
                exit 0
            ;;

            encrypt | -encrypt | --encrypt)
                for file in $vault_files; do
                    echo "> $file";
                    ansible-vault encrypt $password_strategy $file
                done
            ;;

            decrypt | -decrypt | --decrypt)
                for file in $vault_files; do
                    echo "> $file"
                    ansible-vault decrypt $password_strategy $file
                done
            ;;

            *)
                echo "OPTION INVALIDE : $1" >&2
                usage
                exit 1
            ;;
        esac
        shift
    done
    }

# Exécution du script principal
handle_options "$@"
