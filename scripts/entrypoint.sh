#!/bin/sh

error() {
  echo $1
  exit 1
}

echo "Setting defaults..."
[ ! -s "$HOSTNAME" ] && export HOSTNAME="nQuake QTV"
[ ! -s "$LISTEN_PORT" ] && export LISTEN_PORT=28000
[ ! -s "$ADMIN_PASSWORD" ] && export ADMIN_PASSWORD="changeme"
[ ! -s "$QTV_PASSWORD" ] && export QTV_PASSWORD="changeme"

echo "Configuring QTV..."
envsubst < /qtv/qtv.cfg.template > /qtv/qtv.cfg || error "Could not configure QTV"

# Add target servers to end of qtv.cfg
added=0
servers=$(echo $TARGET_SERVERS | tr "," "\n")
for server in $servers
do
  added=1
  echo "qtv $server" >> /qtv/qtv.cfg
done
[ "$added" = "0" ] && error "No target servers specified"

echo "Starting QTV"
cd /qtv
./qtv.bin +exec qtv.cfg || error "Could not start QTV"
