#!/bin/bash

# 環境変数のチェック
if [ -z "$MINECRAFT_BASE_DIR" ]; then
    echo "MINECRAFT_BASE_DIR is not set"
    exit 1
fi

export LD_LIBRARY_PATH=.
SERVER_DIR=$MINECRAFT_BASE_DIR/minecraft_bedrock
SCREEN_NAME="minecraft_server"

start_server() {
    echo "Starting Minecraft server..."
    cd "$SERVER_DIR"
    screen -dmS "$SCREEN_NAME" ./bedrock_server &
}

start_server
