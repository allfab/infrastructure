Role Name
=========

A brief description of the role goes here.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).


# HEADSCALE - TAILSCALE

## Docker

docker compose exec headscale headscale users create allfab
docker compose exec headscale headscale preauthkeys create -e 10m -u allfab

Afin que le conteneur docker `tailscale` s'authentifie bien avec `headscale`, il est nécessaire d'ajouter la configuration `hostname` au fichier compose et que ce `hostname` corresponde bien à un utilisateur sur headscale. C'est pourquou on retrouve :
``` yaml
tailscale:
    container_name: tailscale
    image: tailscale/tailscale:latest
    `hostname: docker`
    ...
```

docker compose exec headscale headscale users create frontend-tail
docker compose exec headscale headscale preauthkeys create -e 10m -u frontend-tail
docker compose exec headscale headscale preauthkeys create --reusable -u frontend-tail

# Connect to headscale-webui
docker compose exec headscale headscale apikeys create

## docker tailscale
tailscale up --login-server=https://headscale.allfabox.fr --advertise-exit-node --advertise-routes=192.168.0.0/16 --accept-dns=true



https://headscale.net/running-headscale-linux/#register-a-machine-normal-login

sudo tailscale up --login-server https://headscale.allfabox.fr

sudo tailscale login --login-server https://headscale.allfabox.fr

sudo tailscale up --login-server https://headscale.allfabox.fr --authkey xxxxxxxxxxxxxxxxxxxxxxxxxxxx

tailscale up --login-server https://headscale.allfabox.fr --authkey xxxxxxxxxxxxxxxxxxxxxxxxxxxx

### Nodes

docker compose exec headscale headscale nodes list

### Routes

docker compose exec headscale headscale routes list
docker compose exec headscale headscale routes enable -r <ID>


## Windows Client 
https://github.com/juanfont/headscale/blob/main/docs/windows-client.md

New-Item -Path "HKLM:\SOFTWARE\Tailscale IPN"
New-ItemProperty -Path 'HKLM:\Software\Tailscale IPN' -Name UnattendedMode -PropertyType String -Value always
New-ItemProperty -Path 'HKLM:\Software\Tailscale IPN' -Name LoginURL -PropertyType String -Value https://headscale.allfabox.fr