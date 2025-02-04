#!/bin/bash

set -x

cd /data


if ! [[ -f serverinstall_91_2105 ]]; then
	curl -o serverinstall_91_2105 https://api.modpacks.ch/public/modpack/91/2105/server/linux
	chmod +x serverinstall_91_2105
	./serverinstall_91_2093 --path /data --auto
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

if ! [[ "$EULA" = "false" ]]; then
	echo "eula=true" > eula.txt
fi

curl -o log4j2_112-116.xml https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml
java -server -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Dfml.queryResult=confirm -Dlog4j.configurationFile=log4j2_112-116.xml $JVM_OPTS -jar forge-1.16.5-36.2.9.jar nogui