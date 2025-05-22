#!/bin/sh

docker exec qrater-db-1 \
  /usr/bin/mysqldump --single-transaction -u root -p$(cat db-password.txt) qrater | gzip > qrater_backup_$(date +%Y%m%d).sql.gz
