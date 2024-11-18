<!-- @format -->

# Setup

## Set env

```bash
export GCS_BACKUP_BUCKET=gs://xxx/minecraft/
export MINECRAFT_BASE_DIR=/home/xxx/
export GOOGLE_APPLICATION_CREDENTIALS=/home/xxx/.ssh/gcs_service_account.json
```

## Install

```bash
sudo apt update
# install CGP https://cloud.google.com/sdk/docs/install?hl=ja

mkdir /path/to/minecraft
cd /path/to/minecraft
mkdir bak
git clone https://github.com/kaibadash/minecraft_bedrock_scripts.git

wget https://minecraft.azureedge.net/bin-linux/bedrock-server-XXX.zip
unzip bedrock*zip
```

# Restore

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/gcs.json
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

cd /path/to/minecraft/bak
gsutil cp gs://xxx/minecraft_backup_*.tar.gz ./
cd /path/to/minecraft
tar xzvf bak/minecraft_backup_*.tar.gz
```

# Daily backup

```
0 13 * * * /home/kaibadash/minecraft_bedrock_scripts/update.sh
```
