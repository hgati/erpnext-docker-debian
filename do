#!/usr/bin/env bash

usage() {
    echo "docker named volume backup & restore utility"
    echo "Usage: do <backup|restore>"
    exit
}

_backup() {
    docker volume ls

    docker-compose stop frappe

    docker run -v mybiz_frappe-apps-volumes:/volume -v $(pwd)/backup:/backup --rm loomchild/volume-backup \
        backup mybiz_frappe-apps-volumes
    docker run -v mybiz_frappe-logs-volumes:/volume -v $(pwd)/backup:/backup --rm loomchild/volume-backup \
        backup mybiz_frappe-logs-volumes
    docker run -v mybiz_frappe-sites-volumes:/volume -v $(pwd)/backup:/backup --rm loomchild/volume-backup \
        backup mybiz_frappe-sites-volumes
    docker run -v mybiz_mariadb-data-volumes:/volume -v $(pwd)/backup:/backup --rm loomchild/volume-backup \
        backup mybiz_mariadb-data-volumes

    docker-compose start frappe
}

_restore() {
    docker volume ls

    docker-compose stop frappe

    docker run -v mybiz_frappe-apps-volumes:/volume -v $(pwd)/backup:/backup --rm loomchild/volume-backup \
        restore mybiz_frappe-apps-volumes
    docker run -v mybiz_frappe-logs-volumes:/volume -v $(pwd)/backup:/backup --rm loomchild/volume-backup \
        restore mybiz_frappe-logs-volumes
    docker run -v mybiz_frappe-sites-volumes:/volume -v $(pwd)/backup:/backup --rm loomchild/volume-backup \
        restore mybiz_frappe-sites-volumes
    docker run -v mybiz_mariadb-data-volumes:/volume -v $(pwd)/backup:/backup --rm loomchild/volume-backup \
        restore mybiz_mariadb-data-volumes

    docker-compose start frappe
}

sleep 1

if [ $# -ne 1 ]; then
    usage
fi

OPERATION=$1

case "$OPERATION" in
"backup" )
_backup
;;
"restore" )
_restore
;;
* )
usage
;;
esac