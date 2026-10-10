
#!/bin/bash
# Скрипт резервного копирования

BACKUP_DIR="$HOME/lab_admin/backup"
DATA_DIR="$HOME/lab_admin/data"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="$BACKUP_DIR/backup_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"
tar -czf "$ARCHIVE" "$DATA_DIR"

echo "Архив создан: $ARCHIVE"
ls -lh "$ARCHIVE"

# Удалить старые архивы (старше 7 дней)
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +7 -delete

