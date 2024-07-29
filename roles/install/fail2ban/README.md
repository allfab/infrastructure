# https://www.it-connect.fr/filtres-et-actions-personnalises-dans-fail2ban/

# Filtre traefik-general-forceful-browsing.conf
docker compose exec fail2ban sh
fail2ban-regex /var/log/traefik/traefik-access.log /etc/fail2ban/filter.d/traefik-general-forceful-browsing.conf
docker exec -it fail2ban fail2ban-regex /var/log/traefik/access.log /etc/fail2ban/filter.d/traefik-general-forceful-browsing.conf

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
docker exec -it fail2ban fail2ban-client set traefik unbanip 92.184.107.122
fail2ban-client set traefik unbanip 92.184.107.94
fail2ban-client set proxmox unbanip 192.168.10.10

# Log Jail
fail2ban-regex systemd-journal /etc/fail2ban/filter.d/proxmox.conf
fail2ban-regex systemd-journal /etc/fail2ban/filter.d/pam-generic.conf

fail2ban-client status | sed -n 's/,//g;s/.*Jail list://p' | xargs -n1 fail2ban-client status
alias showbans="fail2ban-client status | sed -n 's/,//g;s/.*Jail list://p' | xargs -n1 fail2ban-client status"

# Notification
curl -d "{\"chatId\": \"33060000000@c.us\", \"text\": \"Test des bois via CURL\", \"session\": \"default\" }" -H "Content-Type: application/json" -X POST http://192.168.10.10:3011/api/sendText

curl -X 'POST' \
    'http://192.168.10.10:3011/api/sendText' \
    -d "{\"chatId\": \"33060000000@c.us\", \"text\": \"Test des bois via CURL\" }" \
    -H "Content-Type: application/json"

# Via Swagger
curl -X 'GET' \
  'https://mydomain/api/sessions?all=true' \
  -H 'accept: application/json'

curl -X 'GET' \
  'https://mydomain/api/screenshot?session=default' \
  -H 'accept: */*' \
  --output ./waha/waha-default-session-qrcode.png

curl -X 'POST' \
  'https://mydomain/api/sendText' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{"chatId": "33060000000@c.us", "text": "Via CURL", "session": "default"}'

curl -X 'POST' 'https://mydomain/api/sendText' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"chatId": "33060000000@c.us", "text": "Via CURL - Inline command", "session": "default"}'

curl -X 'POST' 'http://192.168.10.10:3011/api/sendText' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"chatId": "33060000000@c.us", "text": "Via CURL - Inline command", "session": "default"}'


