#!/bin/bash
#
# Ansible Vault Secrets Git Hook
# .git/hooks/pre-commit

set -o nounset

FILE_PATTERN="vault.yml"
ENCRYPTED_PATTERN="\$ANSIBLE_VAULT;"

is_encrypted() {
    local file=$1
    if ! git show :"$file" | grep --quiet "^${ENCRYPTED_PATTERN}"; then
        printf "Localisation d'un fichier coffre-fort (vault.yml) qui doit être chiffré :\n > %s\n" ${file}
        exit 1
    fi
}

echo "Ansible Vault Secrets Pre-Commit Git Hook"
git diff --cached --name-only | grep "${FILE_PATTERN}" | while IFS= read -r line; do
    is_encrypted "${line}"
done