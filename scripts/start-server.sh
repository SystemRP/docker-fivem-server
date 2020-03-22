#!/bin/bash
CUR_V="$(find ${SERVER_DIR} -name fiveminstalled-* | cut -d '-' -f 2,3)"
LAT_V="$(curl -s https://fivem.gbps.io/linux/${VERSION} | cut -d '-' -f 1 | cut -d '/' -f 8)"
DL_URL=$(curl -s https://fivem.gbps.io/linux/${VERSION})

if [ ! -f ${SERVER_DIR}/fiveminstalled-* ]; then
    if [ "${LAT_V}" == "" ]; then
        if [ ! -f ${SERVER_DIR}/fx.tar.xz ]; then
            echo "-------------------------------------------------------------------------"
            echo "--------Could not get latest game version from master server-------------"
            echo "----------please put the Server file 'fx.tar.xz' in the main-------------"
            echo "-----------------directory, you can get it from:-------------------------"
            echo "---https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/---"
            echo "----------and restart the Docker, putting Server into sleep mode---------"
            echo "-------------------------------------------------------------------------"
            sleep infinity
        else
            echo "---File 'fx.tar.xz' found, installing...---"
            cd ${SERVER_DIR}
            tar -xf fx.tar.xz
            sleep 2
            rm -R fx.tar.xz
            touch ${SERVER_DIR}/fiveminstalled-manual
            echo "---Installation of new 'fx.tar.xz' complete---"
        fi
    elif [ "$LAT_V" != "" ]; then
        echo "---FiveM not found, downloading!---"
        cd ${SERVER_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll "$DL_URL" ; then
                echo "---Download complete---"
        else
                echo "---Something went wrong, can't download FiveM, putting server in sleep mode---"
                sleep infinity
        fi
        tar -xf fx.tar.xz
        rm -R fx.tar.xz
        touch ${SERVER_DIR}/fiveminstalled-$LAT_V
        echo "---Installation of new 'fx.tar.xz' complete---"
        CUR_V="$(find ${SERVER_DIR} -name fiveminstalled-* | cut -d '-' -f 2,3)"
        fi
fi
echo "---Version Check---"

if [ "$LAT_V" == "" ]; then
    echo "-------------------------------------------------------"
    echo "----Could not get latest version from master server----"
    echo "---please check manualy if there is a newer version---"
    echo "---and place the file manualy in the main directory---"
    echo "-------------------------------------------------------"
    if [ -f ${SERVER_DIR}/fx.tar.xz ]; then
        echo "---File 'fx.tar.xz' found, installing...---"
        if [ -f ${SERVER_DIR}/fiveminstalled-* ]; then
            rm ${SERVER_DIR}/fiveminstalled-*
        fi
        cd ${SERVER_DIR}
        tar -xf fx.tar.xz
        sleep 2
        rm -R fx.tar.xz
        touch ${SERVER_DIR}/fiveminstalled-manual
        echo "---Installation of new 'fx.tar.xz' complete---"
    fi
elif [ "$LAT_V" != "$CUR_V" ]; then
    echo "---Newer version found, installing!---"
    if [ -f ${SERVER_DIR}/fiveminstalled-* ]; then
        rm ${SERVER_DIR}/fiveminstalled-*
    fi
    cd ${SERVER_DIR}
    if wget -qO fx.tar.xz -nc --show-progress --progress=bar:force:noscroll "$DL_URL" ; then
        echo "---Download complete---"
    else
        echo "---Something went wrong, can't download FiveM, putting server in sleep mode---"
        sleep infinity
    fi
    tar -xf fx.tar.xz
    rm ${SERVER_DIR}/fx.tar.xz
    touch fiveminstalled-$LAT_V
elif [ "$LAT_V" == "$CUR_V" ]; then
    echo "---FiveM Version up-to-date---"
fi



if [ ! -d "${SERVER_DIR}/resources" ]; then
  echo "---SERVER-DATA not found, downloading...---"
  cd ${SERVER_DIR}
  wget -qO server-data.zip "http://github.com/citizenfx/cfx-server-data/archive/master.zip"
  unzip -q server-data.zip
  mv ${SERVER_DIR}/cfx-server-data-master/resources ${SERVER_DIR}/resources
  rm server-data.zip && rm -R cfx-server-data-master/
fi

echo "---Prepare Server---"
if [ ! -f "${SERVER_DIR}/server.cfg" ]; then
  echo "---No server.cfg found, downloading...---"
  cd ${SERVER_DIR}
  wget -q -nc --show-progress --progress=bar:force:noscroll server.cfg "https://raw.githubusercontent.com/SystemRP/docker-fivem-server/master/configs/server.cfg"
fi
chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Checking for old logs---"
find ${SERVER_DIR} -name "masterLog.*" -exec rm -f {} \;

if [ ! -f ${SERVER_DIR}/run.sh ]; then
	echo "------------------------------------"
	echo "---Something went wrong, couldn't---"
    echo "---find run.sh in main directory----"
    echo "---Putting server into sleep mode---"
    echo "------------------------------------"
    sleep infinity
fi

echo "---Starting Server---"
cd ${SERVER_DIR}
screen -d -m -S FiveM -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m ${SERVER_DIR}/run.sh +exec ${GAME_CONFIG} ${START_VARS}
sleep 2
tail -f ${SERVER_DIR}/masterLog.0