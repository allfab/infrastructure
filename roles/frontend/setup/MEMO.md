# https://www.it-connect.fr/filtres-et-actions-personnalises-dans-fail2ban/

# Filtre traefik.conf
docker compose exec fail2ban sh
fail2ban-regex /var/log/traefik/traefik-access.log /etc/fail2ban/filter.d/traefik.conf
docker exec -it fail2ban fail2ban-regex /var/log/traefik/access.log /etc/fail2ban/filter.d/traefik.conf

docker exec -it fail2ban fail2ban-regex /var/log/daemon.log /etc/fail2ban/filter.d/proxmox.conf

# Statut fail2ban
fail2ban-client status
docker exec -it fail2ban fail2ban-client status

# Statut du filtre 
fail2ban-client status traefik
docker exec -it fail2ban fail2ban-client status traefik

# Statut d'une prison
fail2ban-client status jail.conf

# Recharger fial2ban
fail2ban-client reload

# Statut d'une prison
docker exec -it fail2ban fail2ban-client status <jail name>

# Débannir une adresse IP
docker exec -it fail2ban fail2ban-client set <jail name> unbanip <IP>
docker exec -it fail2ban fail2ban-client set traefik unbanip 92.184.104.95
docker exec -it fail2ban fail2ban-client set pam-generic unbanip 192.168.10.10
fail2ban-client set traefik unbanip 92.184.104.95
fail2ban-client set pam-generic unbanip 192.168.10.10

# Proxmox
fail2ban-regex systemd-journal /etc/fail2ban/filter.d/proxmox.conf

fail2ban-client status | sed -n 's/,//g;s/.*Jail list://p' | xargs -n1 fail2ban-client status
alias showbans="fail2ban-client status | sed -n 's/,//g;s/.*Jail list://p' | xargs -n1 fail2ban-client status"


# Notification
curl -d "{\"chatId\": \"33670950706@c.us\", \"text\": \"Test des bois via CURL\", \"session\": \"default\" }" -H "Content-Type: application/json" -X POST http://192.168.10.10:3011/api/sendText

curl -X 'POST' \
    'http://192.168.10.10:3011/api/sendText' \
    -d "{\"chatId\": \"33670950706@c.us\", \"text\": \"Test des bois via CURL\" }" \
    -H "Content-Type: application/json"

# Via Swagger
curl -X 'GET' \
  'https://waha.allfabox.fr/api/sessions?all=true' \
  -H 'accept: application/json'

curl -X 'GET' \
  'https://waha.allfabox.fr/api/screenshot?session=default' \
  -H 'accept: */*' \
  --output ./waha/waha-default-session-qrcode.png

curl -X 'POST' \
  'https://waha.allfabox.fr/api/sendText' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{"chatId": "33670950706@c.us", "text": "Via CURL", "session": "default"}'

curl -X 'POST' 'https://waha.allfabox.fr/api/sendText' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"chatId": "33670950706@c.us", "text": "Via CURL - Inline command", "session": "default"}'

curl -X 'POST' 'http://192.168.10.10:3011/api/sendText' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"chatId": "33670950706@c.us", "text": "Via CURL - Inline command", "session": "default"}'

# HEADSCALE - TAILSCALE

## Docker
### USERS
```bash
docker compose exec headscale headscale users create allfab
docker compose exec headscale headscale preauthkeys create -e 10m -u allfab
```

Afin que le conteneur docker `tailscale` s'authentifie bien avec `headscale`, il est nécessaire d'ajouter la configuration `hostname` au fichier compose et que ce `hostname` corresponde bien à un utilisateur sur headscale. C'est pourquou on retrouve :
```yaml
tailscale:
    container_name: tailscale
    image: tailscale/tailscale:latest
    `hostname: docker`
    ...
```

``` bash
docker compose exec headscale headscale users create frontend-tail
docker compose exec headscale headscale preauthkeys create -e 10m -u frontend-tail
docker compose exec headscale headscale preauthkeys create --reusable -u frontend-tail
```

## Connect to headscale-admin

``` bash
docker compose exec headscale headscale apikeys create
docker compose exec headscale headscale apikeys list
docker compose exec headscale headscale apikeys expire --prefix "6fyfujHXyw"
```

## docker tailscale
``` bash
tailscale up --login-server=https://headscale.allfabox.fr --advertise-exit-node --advertise-routes=192.168.0.0/16 --accept-dns=true
```

``` bash
# https://headscale.net/running-headscale-linux/#register-a-machine-normal-login

sudo tailscale up --login-server https://headscale.allfabox.fr

sudo tailscale login --login-server https://headscale.allfabox.fr

sudo tailscale up --login-server https://headscale.allfabox.fr --authkey xxxxxxxxxxxxxxxxxxxxxxxxxxxx

tailscale up --login-server https://headscale.allfabox.fr --authkey xxxxxxxxxxxxxxxxxxxxxxxxxxxx

sudo tailscale set --operator=$USER
```

## Nodes

``` bash
docker compose exec headscale headscale nodes list

Register new node :
docker compose exec headscale headscale nodes register --user allfab --key nodekey:0e2f6490d13b0204a8b0721ff5e5f89e7e9881c8377b31e3a5f2f2dcbd86d87e
```

## Routes
``` bash
docker compose exec headscale headscale routes list
docker compose exec headscale headscale routes enable -r <ID>
```

## Windows Client 
https://github.com/juanfont/headscale/blob/main/docs/windows-client.md

``` bash
New-Item -Path "HKLM:\SOFTWARE\Tailscale IPN"
New-ItemProperty -Path 'HKLM:\Software\Tailscale IPN' -Name UnattendedMode -PropertyType String -Value always
New-ItemProperty -Path 'HKLM:\Software\Tailscale IPN' -Name LoginURL -PropertyType String -Value https://headscale.allfabox.fr
```

