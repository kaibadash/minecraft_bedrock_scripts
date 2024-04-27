#!/bin/bash

# 環境変数のチェック
if [ -z "$MINECRAFT_BASE_DIR" ]; then
    echo "MINECRAFT_BASE_DIR is not set"
    exit 1
fi

BACKUP_DIR="$MINECRAFT_BASE_DIR/bak"

cd $MINECRAFT_BASE_DIR

# stop.sh を実行してサーバーを停止し、バックアップ
./stop.sh

tar -czvf "$BACKUP_DIR/minecraft_backup_$DATE_FORMAT.tar.gz" -C "$SERVER_DIR/worlds" .

# start.sh を実行してサーバーを再開
./start.sh

# NOTE: screenセッションにアタッチする場合は以下を有効にする
# screen -r "$SCREEN_NAME"
# detachするには Ctrl+A, D を押す
# command: https://minecraftbedrock-archive.fandom.com/wiki/Commands/List_of_Commands#give
