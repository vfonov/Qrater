#!/bin/sh

CONTAINER="qrater_db_1"


docker exec $CONTAINER \
  /usr/bin/mysqldump --single-transaction -u root -p$(cat db-password.txt) qrater | gzip qrater_backup_$(date +%Y%m%d).sql.gz
