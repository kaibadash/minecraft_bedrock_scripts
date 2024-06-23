<!-- @format -->

# TODO

GCS に bak がアップされていない

# スペックアップ

VM 停止
e2-medium 2CPU 4G => 4CPU 6GB

# memo

```
+ rm allowlist.json permissions.json server.properties
+ cd /home/kaibadash/
+ ./restart_backup.sh
/home/kaibadash/minecraft_bedrock_scripts/update.sh: line 74: ./restart_backup.sh: No such file or directory
+ cp -rf ./bak ./bedrock_server ./classic_minecraft ./minecraft_bedrock ./minecraft_bedrock_scripts ./snap ./update_tmp ./version_info.txt ./minecraft_bedrock/
```
