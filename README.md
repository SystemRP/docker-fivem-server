# FiveM Server in Docker optimized for Unraid
With this Docker you can run FiveM (GTA V MOD SERVER) it will automatically download the latest version or if you want to updated it yourself set the 'Manual Updates' to 'true' (without quotes).

This will fetch the version in the VERSION env var, by default development.

The Docker will automatically extract it and download all other required files (resources, server.cfg).
You can get fx.tar.xz from here: https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/

Notice: Simply restart the container and it will download the newest version or if you set 'Manual Updates' to 'true' place the new fx.tar.xz in the main directory and restart the container.

>**CONSOLE:** To connect to the console open up the terminal on the host machine and type in: 'docker exec -u fivem -ti [Name of your Container] screen -xS FiveM' (without quotes) to exit the screen session press CTRL+A and then CTRL+D or simply close the terminal window in the first place.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_CONFIG | The name of your server configuration file | server.cfg |
| VERSION | Either stable, optional or development | development |
| START_VARS | Enter your extra startup variables here if needed | |
| MANUAL_UPDATES | Set to 'true' if you want to update the server manually (otherwise leave blank) | *blank* |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name FiveM -d \
    -p 30110:30110 -p 30120:30120 \
    -p 30110:30110/udp -p 30120:30120/udp \
    --env 'GAME_CONFIG=server.cfg' \
    --env 'VERSION=development' \
    --env 'UID=99' \
    --env 'GID=100' \
    --volume /mnt/user/fivem:/server/data \
    systemrp/fivem
```


This Docker was mainly edited for better use with UnRAID, if you don't use UnRAID you should definitely try it!

#### Support Thread: 