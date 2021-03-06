#!/usr/.bin/bash

# Copyright (c) 2020 yuk7 <yukx00@gmail.com>
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php


export PATH=/usr/.bin:$PATH

CONTAINER_PID=$(pgrep -xo wsl2_isocond.sh)

# if the container daemon isn't running, run it.
if [ "$CONTAINER_PID" = '' ] ; then
    daemonize /usr/.bin/unshare --fork --pid --mount-proc /init_wsl2/wsl2_isocond.sh
    daemonize /init_wsl2/syncbin.sh
fi

while [[ "${CONTAINER_PID}" = '' ]]; do
    CONTAINER_PID=$(pgrep -xo wsl2_isocond.sh)
    sleep 0.01
done

exec nsenter -t ${CONTAINER_PID} --all --wd="${PWD}" /usr/.bin/bash -- /init_wsl2/isocon_sh.sh ${INIT_WSL_UID} "${@}"