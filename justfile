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

morpheus-destroy-infra:
  ansible-playbook -i hosts.ini run.yml --limit morpheus --tags "destroy-infra, morpheus-destroy-infra"

# frontend:
#   ansible-playbook -i hosts.ini run.yml --limit frontend --tags setup

frontend:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab --limit frontend --tags setup

elephant:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab --limit elephant --tags setup

smarthome:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab --limit smarthome --tags setup

jellyfin:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab --limit jellyfin --tags setup

mediaserver:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab --limit mediaserver --tags setup

nextcloud:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab --limit nextcloud --tags setup

immich:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab --limit immich --tags setup

webapps:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab --limit webapps --tags setup

monitoring:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab --limit monitoring --tags setup

communication:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab --limit communication --tags setup

vps-frontend:
  ansible-playbook -i hosts.ini run.yml --user allfab --private-key ~/.ssh/allfab-vps-hetzner --limit hetzner --tags setup

# Ansible Vault Encrypt
encrypt:
  @if (grep --quiet "vault_password_file" ansible.cfg); then ansible-vault encrypt ./vars/vault.yml; else ansible-vault encrypt --vault-password-file bw-vault.sh ./vars/vault.yml; fi

# Ansible Vault Decrypt
decrypt:
  @if (grep --quiet "vault_password_file" ansible.cfg); then ansible-vault decrypt ./vars/vault.yml; else ansible-vault decrypt --vault-password-file bw-vault.sh ./vars/vault.yml; fi

yamllint:
  yamllint -s .

ansible-lint: yamllint
  #!/usr/bin/env bash
  ansible-lint .
  ansible-playbook run.yml --syntax-check
