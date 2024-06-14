#!/bin/bash

SERVER_DIR=$MINECRAFT_BASE_DIR/minecraft_bedrock
BACKUP_DIR="$MINECRAFT_BASE_DIR/bak"

create_backup() {
    DATE_FORMAT=$(date +%Y%m%d_%H%M%S)
    tar -czvf "$BACKUP_DIR/minecraft_backup_$DATE_FORMAT.tar.gz" -C "$SERVER_DIR/worlds" .
}

cleanup_old_backups() {
    find $BACKUP_DIR -type f -name "*.tar.gz" -mtime +3 -exec rm {} \;
}

# 環境変数のチェック
if [ -z "$MINECRAFT_BASE_DIR" ]; then
    echo "MINECRAFT_BASE_DIR is not set"
    exit 1
fi

cd `dirname $0`
create_backup
cleanup_old_backups

# NOTE: screenセッションにアタッチする場合は以下を有効にする
# screen -r "$SCREEN_NAME"
# detachするには Ctrl+A, D を押す
# command: https://minecraftbedrock-archive.fandom.com/wiki/Commands/List_of_Commands#give
