#!/bin/bash

set -e

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/opt/db-backups"
BACKUP_FILE="pesco_db_${TIMESTAMP}.sql.gz"
S3_BUCKET="pesco-db-backups"

mkdir -p $BACKUP_DIR

docker exec ps_postgres pg_dump -U pesco pesco_db | gzip > $BACKUP_DIR/$BACKUP_FILE

aws s3 cp $BACKUP_DIR/$BACKUP_FILE s3://$S3_BUCKET/

# Optional cleanup (keep local disk clean)
find $BACKUP_DIR -type f -mmin +10 -delete

