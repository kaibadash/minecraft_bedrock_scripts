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

upload() {
    # 認証が必要?
    # gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

    # 最新の.tgzファイルを見つける
    latest_tgz=$(ls -t $BACKUP_DIR/*.tar.gz | head -1)

    # 最新の.tgzファイルをGoogle Cloud Storageにアップロード
    if [ -f "$latest_tgz" ]; then
        filename=$(basename "$latest_tgz")
        gsutil cp "$latest_tgz" "$GCS_BACKUP_BUCKET""$filename"
        echo "File uploaded successfully."
    else
        echo "No .tgz file found."
        exit 2
    fi
}

# 環境変数のチェック
if [ -z "$MINECRAFT_BASE_DIR" ]; then
    echo "MINECRAFT_BASE_DIR is not set"
    exit 1
fi
if [ -z "$GCS_BACKUP_BUCKET" ]; then
    echo "GCS_BACKUP_BUCKET is not set"
    exit 2
fi
if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo "GOOGLE_APPLICATION_CREDENTIALS is not set"
    exit 3
fi

cd `dirname $0`
create_backup
cleanup_old_backups
upload

# NOTE: screenセッションにアタッチする場合は以下を有効にする
# screen -r "$SCREEN_NAME"
# detachするには Ctrl+A, D を押す
# command: https://minecraftbedrock-archive.fandom.com/wiki/Commands/List_of_Commands#give
