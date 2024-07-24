# Docker

## Comment effacer correctement les logs d'un conteneur Docker ?
```
sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/*-json.log"
```