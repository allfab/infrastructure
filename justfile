# Recettes
@default:
  just --list

init-infra:
  @./init-infra.sh

timezone:
  ansible-playbook -i hosts.ini run.yml --limit all --tags timezone

pve-config-base:
  ansible-playbook -i hosts.ini run.yml --limit pve --tags config

pve-config-base-tags TAGS:
  ansible-playbook -i hosts.ini run.yml --limit pve --tags "{{TAGS}}"

morpheus:
  ansible-playbook -i hosts.ini run.yml --limit morpheus --tags setup

morpheus-tags TAGS:
  ansible-playbook -i hosts.ini run.yml --limit morpheus --tags "{{TAGS}}"

morpheus-lnxlink:
  ansible-playbook -i hosts.ini run.yml --limit morpheus --tags "lnxlink, lnxlink-setup"

frontend:
  ansible-playbook -i hosts.ini run.yml --limit frontend --tags setup

elephant:
  ansible-playbook -i hosts.ini run.yml --limit elephant --tags setup

smarthome:
  ansible-playbook -i hosts.ini run.yml --limit smarthome --tags setup

jellyfin:
  ansible-playbook -i hosts.ini run.yml --limit jellyfin --tags setup

mediaserver:
  ansible-playbook -i hosts.ini run.yml --limit mediaserver --tags setup

webapps:
  ansible-playbook -i hosts.ini run.yml --limit webapps --tags setup

monitoring:
  ansible-playbook -i hosts.ini run.yml --limit monitoring --tags setup

# Ansible Vault Encrypt
ansible-encrypt:
  @if (grep --quiet "vault_password_file" ansible.cfg); then ansible-vault encrypt ./vars/vault.yml; else ansible-vault encrypt --vault-password-file bw-vault.sh ./vars/vault.yml; fi

# Ansible Vault Decrypt
ansible-decrypt:
  @if (grep --quiet "vault_password_file" ansible.cfg); then ansible-vault decrypt ./vars/vault.yml; else ansible-vault decrypt --vault-password-file bw-vault.sh ./vars/vault.yml; fi

yamllint:
  yamllint -s .

ansible-lint: yamllint
  #!/usr/bin/env bash
  ansible-lint .
  ansible-playbook run.yml --syntax-check
