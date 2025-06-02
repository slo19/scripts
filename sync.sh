#!/bin/bash

RCLONE_SYNC_PATH="${HOME}/workspace/Obsidian"
RCLONE_REMOTE="drive:/Obsidian"
REMOTE_NAME="Drive-Obsidian"


RCLONE_OUT_CMD="rclone sync ${RCLONE_SYNC_PATH} ${RCLONE_REMOTE} --checksum --update --verbose"

RCLONE_IN_CMD="rclone sync ${RCLONE_REMOTE} ${RCLONE_SYNC_PATH} --checksum --update --verbose"

RCLONE_RESYNC="rclone bisync ${RCLONE_SYNC_PATH} ${RCLONE_REMOTE} --resync"

WATCH_EVENTS="modify,delete,create,move"

SYNC_DELAY=5 # seconds

SYNC_INTERVAL=60 # seconds

NOTIFY_ENABLE=true

SYNC_SCRIPT=$(realpath $0)

notify() {
  MESSAGE=$1
  notify-send "rclone ${REMOTE_NAME}" "${MESSAGE}"
}

send_2_cloud() {
  ${RCLONE_RESYNC} 
}

send() {
  set +x
  ${RCLONE_OUT_CMD}
  set -x
}

get() {
  set +x
  ${RCLONE_IN_CMD}
  set -x
}

rclone_sync() {
  set +x
  ${RCLONE_IN_CMD} && notify "Startup"

  while [[ true ]] ; do
  inotifywait --recursive --timeout ${SYNC_INTERVAL} -e ${WATCH_EVENTS} \
    ${RCLONE_SYNC_PATH} 2>/dev/null
  
  if [ $? -eq 0 ]; then
    send && notify "Synchronized local -> cloud"
  else
    get && notify "Synchronizing cloud -> local"
    sleep ${SYNC_DELAY} 
  fi
  done
}

systemd_setup() {
  set -x 
  if loginctl show-user ${USER} | grep "Linger=no"; then
    echo "User account does not allow systemd Linger."
    echo "To enable lingering, run as root: loginctl enable-linger $USER"
    echo "Then try running his command again."
    exit 1
  fi  
  mkdir -p ${HOME}/.config/systemd/user
  SERVICE_FILE=${HOME}/.config/systemd/user/rclone_sync.${REMOTE_NAME}.service
  if test =f ${SERVICE_FILE}; then
    echo "Unit file already exists: ${SERVICE_FILE} - Not overwriting."
  else
    cat <<EOF > ${SERVICE_FILE}
[Unit]
Description=rclone_sync ${REMOTE_NAME}

[Service]
ExecStart=${SYNC_SCRIPT}

[Install]
WantedBy=default.target
EOF
  fi
  systemctl --user daemon-reload
  systemctl --user enable --now rclone_sync.${REMOTE_NAME}
  systemctl --user status rclone_sync.${REMOTE_NAME}
  echo "You can watch the logs with this command:"
  echo "    journalctl --user --unit rclone_sync.${REMOTE_NAME}"
}

if test $# = 0; then
  rclone_sync
else
  CMD=$1; shift;
  ${CMD} $@
fi
