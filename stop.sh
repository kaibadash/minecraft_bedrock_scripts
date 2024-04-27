#!/bin/bash

# 環境変数のチェック
if [ -z "$MINECRAFT_BASE_DIR" ]; then
    echo "MINECRAFT_BASE_DIR is not set"
    exit 1
fi

export LD_LIBRARY_PATH=.
SERVER_DIR=$MINECRAFT_BASE_DIR/minecraft_bedrock
BACKUP_DIR="$MINECRAFT_BASE_DIR/bak"
SCREEN_NAME="minecraft_server"
DATE_FORMAT=$(date +%Y%m%d_%H%M%S)

send_command_to_screen() {
    screen -S "$SCREEN_NAME" -p 0 -X stuff "$1\r"
}

wait_for_server_shutdown() {
    echo "Waiting for server to shut down..."
    sleep 30
}

create_backup() {
    tar -czvf "$BACKUP_DIR/minecraft_backup_$DATE_FORMAT.tar.gz" -C "$SERVER_DIR/worlds" .
}

cleanup_old_backups() {
    find $BACKUP_DIR -type f -name "*.tar.gz" -mtime +3 -exec rm {} \;
}

# サーバー停止コマンドをスクリーンに送信
send_command_to_screen "say Server is shutting down for backup."
send_command_to_screen "save-all"
send_command_to_screen "stop"

wait_for_server_shutdown
create_backup
cleanup_old_backups
