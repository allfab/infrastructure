#!/bin/bash
#
# Ansible Vault Secrets Git Hook
# .git/hooks/pre-commit
# Hook de pré-commit pour garantir que l'ensemble des fichiers vault.yaml soit chiffré

if [ -d .git/ ]; then
rm -f .git/hooks/pre-commit
cat <<EOT >> .git/hooks/pre-commit
#!/bin/bash
#
# Ansible Vault Secrets Git Hook
# .git/hooks/pre-commit
# Hook de pré-commit pour garantir que l'ensemble des fichiers vault.yaml soit chiffré

vault_files=\$(find . -type f -iwholename "*vault.yml")
vault_files=\$(echo "\$vault_files" | tr " " "\n" | sort -dr | tr "\n" " ")
for file in \$vault_files; do
    echo "> \$file"
    if ( grep --quiet "\$ANSIBLE_VAULT;" \$file);
    then
    echo "Fichier coffre-fort (vault.yml) crypté. Vous pouvez réaliser ce commit en toute sécurité."
    else
    echo "Fichier coffre-fort (vault.yml) non crypté ! Cryptez-le et recommencez l'opération."
    exit 1
    fi
done
EOT

fi

chmod +x .git/hooks/pre-commit