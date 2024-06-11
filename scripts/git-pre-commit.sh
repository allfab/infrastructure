#!/bin/bash
#
# Ansible Vault Secrets Git Hook
# .git/hooks/pre-commit
# Hook de pré-commit pour garantir que l'ensemble des fichiers vault.yaml sont chiffrés

if [ -d .git/ ]; then
rm -f .git/hooks/pre-commit
cat <<EOT >> .git/hooks/pre-commit
#!/bin/bash
#
# Ansible Vault Secrets Git Hook
# .git/hooks/pre-commit

set -o nounset

is_encrypted() {
    local file=$1
    if ! git show :"vault.yml" | grep --quiet "^\$ANSIBLE_VAULT;"; then
        printf "Localisation d'un fichier coffre-fort (vault.yml) non chiffré :\n > %s\n" ${file}
        exit 1
    fi
}

echo "Ansible Vault Secrets Pre-Commit Git Hook"
git diff --cached --name-only | grep "vault.yml" | while IFS= read -r line; do
    is_encrypted "${line}"
done
EOT
fi

chmod +x .git/hooks/pre-commit