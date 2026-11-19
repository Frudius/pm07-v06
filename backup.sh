#!/bin/bash
source "$HOME/pm07/config.sh"

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.sql"

echo "[$TIMESTAMP] Starting backup for $DB_NAME" >> "$LOG_FILE"

mariadb-dump "$DB_NAME" > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    SHA256=$(sha256sum "$BACKUP_FILE" | awk '{print $1}')
    echo "[$TIMESTAMP] SUCCESS: Backup created. SHA-256: $SHA256" >> "$LOG_FILE"
    
    # Индивидуальное дополнение: оставляем только 3 последних файла
    ls -1t "$BACKUP_DIR"/*.sql 2>/dev/null | tail -n +4 | xargs -r rm --
    
    exit 0
else
    echo "[$TIMESTAMP] ERROR: Backup failed!" >> "$LOG_FILE"
    exit 1
fi
