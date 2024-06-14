#!/bin/bash

# Env
# export GCS_BACKUP_BUCKET=gs://you_backet/minecraft/
# export MINECRAFT_BASE_DIR=/home/you/
if [ -z "$GCS_BACKUP_BUCKET" ]; then
    echo "GCS_BACKUP_BUCKET is not set"
    exit 1
fi
if [ -z "$MINECRAFT_BASE_DIR" ]; then
    echo "MINECRAFT_BASE_DIR is not set"
    exit 1
fi
if [ ! -d $MINECRAFT_BASE_DIR/minecraft_bedrock ]; then
    echo "Minecraft Bedrock directory not found. Install Minecraft Bedrock server to $MINECRAFT_BASE_DIR/minecraft_bedrock"
    exit 1
fi

SCRIPT_DIR="$MINECRAFT_BASE_DIR/minecraft_bedrock_scripts"
cd $SCRIPT_DIR/
./stop.sh
./backup.sh

# バージョン情報を保存するファイル
version_file="$MINECRAFT_BASE_DIR/version_info.txt"

# テンポラリディレクトリの削除と作成
tmp_dir=update_tmp
rm -rf $tmp_dir
mkdir $tmp_dir

# Minecraft BedrockサーバーのzipファイルのURLを取得
version=$(curl -sA "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36" https://www.minecraft.net/en-us/download/server/bedrock | grep -oP 'https://minecraft.azureedge.net/bin-linux/bedrock-server-\K[^"]+(?=.zip)')

# 現在のバージョンをファイルから読み込み
if [ -f "$version_file" ]; then
    read -r current_version < "$version_file"
else
    current_version=""
fi

# バージョンが更新されていない場合はスキップ
if [ "$version" = "$current_version" ]; then
    echo "No update needed. Current version: $version"
    exit 0
fi

# zipファイルのダウンロード
zip_file="$tmp_dir/bedrock-server.zip"
wget https://minecraft.azureedge.net/bin-linux/bedrock-server-$version.zip -O $zip_file
if [ -f $zip_file ]; then
    echo "Downloaded zip file: $zip_file"
else
    echo "Failed to download the server zip file. version:$version"
    exit 1
fi

# 最新の.tgzファイルを見つける
latest_tgz=$(ls -t ./bak/*.tar.gz | head -1)

# 最新の.tgzファイルをGoogle Cloud Storageにアップロード
if [ -f "$latest_tgz" ]; then
    filename=$(basename "$latest_tgz")
    gcloud storage cp "$latest_tgz" "$GCS_BACKUP_BUCKET""$filename"
    echo "File uploaded successfully."
else
    echo "No .tgz file found."
    exit 2
fi

# ダウンロードしたzipファイルを指定ディレクトリに移動して処理
cd $tmp_dir
unzip bedrock-server.zip
rm *json *properties
cp -rf ./* $MINECRAFT_BASE_DIR/minecraft_bedrock/

# 新しいバージョン情報をファイルに保存
echo "$version" > "$version_file"
echo "Update completed successfully: $version"
./start.sh
