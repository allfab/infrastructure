<h1 align="center">
  <br>
  <a href="https://perfecthomelab.allfabox.fr/"><img src="https://github.com/allfab/docker-homeassistant-assist-stack/assets/1840185/a83bea0c-37be-4520-af3a-33a71da2deb2" alt="Perfect Homelab" width="200px"></a>
  <br>
  Infrastructure As Code
  <br>
  Ansible
  <br>
</h1>

<h4 align="center">Ce référentiel contient le code utilisé pour déployer et gérer mes différents conteneurs LXC sur Proxmox.<br />Ansible est le principal outil avec lequel je déploie cette infrastructure.</h4>

<p align="center">
  <a href="https://perfecthomelab.allfabox.fr/" target="_blank"><img src="https://img.shields.io/badge/Perfect_Homelab-526CFE?style=for-the-badge&logo=MaterialForMkDocs&logoColor=white" /></a>
  <a href="https://www.ansible.com/" target="_blank"><img src="https://img.shields.io/badge/ansible-000000?style=for-the-badge&logo=ansible&logoColor=white" /></a>
</p>

<p align="center">
  <a href="#pourquoi-ce-dépôt-">Pourquoi ce dépôt ?</a> •
  <a href="#pré-requis">Pré-requis</a> •
  <a href="#instructions-de-déploiement">Instructions de déploiement</a> •
  <a href="#coffre-fort-ansible">Coffre-fort Ansible</a> •
  <a href="#crédits">Crédits</a> •
  <a href="#license">License</a>
</p>

# Pourquoi ce dépôt ?

Ce dépôt contient le code que j'utilise pour déployer et gérer les serveurs de mon homelab :

- Frontend
- Elephant (PostgreSQL)
- Smarthome
- Mediaserver
- Webapss
- Monitoring

 J'utilise Ansible pour exécuter mon infrastructure et ce dépôt est ma contribution au mouvement `Infrastructure as Code`.


 # Pré-requis

 - Python 3,
 - Ansible,
 - [`just`](https://github.com/casey/just) :
    - Installation : `curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin`


# Instructions de déploiement

- `just init-infra` :
    - Installation de la libraire [`just`](https://github.com/casey/just),
    - Installation des rôles Ansible requis (requirements.yml),
    - Installation des collections Ansible requises (requirements.yml),
    - Installation d'un hook github pour éviter de partager sur le dépôt un fichier de coffre-fort non crypté [(en savoir +)](https://github.com/allfab/infrastructure/tree/main?tab=readme-ov-file#ma-gestion-des-secrets).

- `just pve-config-base` :
    - Exécute la commande `ansible-playbook -i hosts.ini run.yml --limit pve --tags config`
    - Ce playbook initialise mes machines hôte Proxmox en jouant les rôles :
        - `pve/community-repo` : Suppression des dépôts `pve-entreprise` et `ceph` + Ajout du dépôt communautaire `pve-no-subscription`,
        - `pve/fake-subscription` : Suppression de la boîte de dialogue Proxmox "No Valid Subscription" si vous n'avez pas de souscription "Enterprise" pour Proxmox,
        - `pve/wake-on-lan` : Installation/Configuration du Wake On Lan (WOL) sur les noeuds Proxmox,
        - `config/users` : Création des utilisateurs Linux,
        - `config/bash-aliases` : Configuration des alias Bash,
        - `grog.package` : Installation des paquets de base,
        - `install/zellij`: Installation de Zellij,
        - `install/motd` : Installation de [figurine](https://github.com/arsham/figurine) et configuration de Message of the Day (MOTD) à la connexion SSH.

- `just morpheus` :
    - Exécute la commande `ansible-playbook -i hosts.ini run.yml --limit morpheus --tags setup`
    - Ce playbook initialise l'infrastructure du Homelab en jouant les rôles :
        - `morpheus`: Déploiement des conteneurs LXC sur Promox,
        - `config/bash-aliases` : Configuration des alias Bash,
        - `grog.package` : Installation des complémentaires aux paquets de base,
        - `install/mergerfs` : Installation et configuration de `mergerfs`,
        - `install/snapraid` : Installation et configuration de `snapraid`.

- `just morpheus-lnxlink` :
    - Exécute la commande `ansible-playbook -i hosts.ini run.yml --limit morpheus --tags "lnxlink, lnxlink-setup"`
    - Ce playbook installe `lnxlink` :
        - `install/lnxlink` : Installation et configuration de `lnxlink` - Monitorer sans effort votre machine Linux à l'aide de MQTT.


# Coffre-fort Ansible

## Raccourci

- `just encrypt` - Chiffre le coffre-fort Ansible :
  - Exécute la commande `ansible-vault encrypt --vault-password-file bw-vault.sh ./vars/vault.yml;`
- `just decrypt` - Décrypte le coffre-fort Ansible :
  - Exécute la commande `ansible-vault decrypt --vault-password-file bw-vault.sh ./vars/vault.yml;`

## PRÉREQUIS : `ansible-vault` - Chiffrement des fichiers vault.yml

### Qu'est-ce qu'Ansible Vault ?

Ansible `Vault` (coffre-fort en français) est une fonctionnalité d'Ansible qui nous permet de conserver des données sensibles telles que des mots de passe, des clés SSH, de certificats SSL, des jetons d'API et tout ce que vous ne voulez pas que le public découvre en parcourant votre dépôt Github, plutôt que de les stocker sous un format brut dans des playbooks ou des rôles.

Il est courant de stocker de telles configurations dans un contrôleur de version tel que git. Nous avons donc besoin d'un moyen de stocker ces données secrètes en toute sécurité.

Le `Vault` est la réponse à notre besoin, puisqu'il permet de chiffrer n'importe quoi à l'intérieur de nos fichiers YAML. Ces données de Vault peuvent ensuite être distribuées ou placées dans le contrôle de code source tel que `git`.

[**➕ En savoir + sur les principales commandes `ansible-vault`**](docs/ansible/ansible-vault.md)


### Ma gestion des secrets

Dans ce projet, j'ai combiné l'utilisation de plusieurs outils pour ma gestion des secrets :
- [`Ansible Vault`](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html),
- [`Bitwarden command-line interface (CLI)`](https://bitwarden.com/help/cli/), qui est l'outil en ligne de commande de [`Bitwarden`](https://bitwarden.com/) qui s'intègre très bien avec l'implémentation alternative de l'API du serveur Bitwarden - [`Vaultwarden`](https://github.com/dani-garcia/vaultwarden) - parfaite pour un déploiement auto-hébergé,
- les `hooks GIT` (notamment avec les hooks de `pre-commit`) afin de ne pas commiter mes fichiers `vault.yml` en clair sur ce dépôt,
- le script `ansible-vault-helper.sh` qui va me permettre de crypter et/ou de décryper les fichiers `vault.yml` présents dans le projet.

[**➕ En savoir +**](docs/ansible/ansible-vault-strategy.md)

# Crédits

Ce dépôt n'existerait pas sans le partage des infrastructures d'[IronicBadger/AlexKTZ](https://github.com/ironicbadger/infra) et de [FuzzyMistborn](https://github.com/FuzzyMistborn/infra). J'ai beaucoup appris en fouillant dans ces dépôts et certaines choses sont copiées directement à partir de ces sources et je les en remercie pour le partage de leur savoir-faire et expérimentation.

Pour finir, un clin d'oeil à [@GuiPoM](https://www.youtube.com/@GuiPoM) sans qui je n'aurais jamais sauté le pas pour construie mon NAS, notamment grâce à sa playlist [G. installé un NAS](https://www.youtube.com/playlist?list=PLMYMkXlcQmZA2TTeyT13eykkc-aM8kU3t).

# Licence

À définir