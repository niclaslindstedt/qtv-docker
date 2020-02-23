#!/bin/sh

error() {
  echo
  echo "ERROR: $1"
  exit 1
}

[ -z "$ADMIN_PASSWORD" ] && error "Please set an ADMIN_PASSWORD"
[ "$ADMIN_PASSWORD" = "changeme" ] && error "Please change the ADMIN_PASSWORD"

echo "=============== nQuake QTV ==============="
echo "Using settings:"
[ -z "$HOSTNAME" ] && export HOSTNAME="nQuake QTV"; echo " * HOSTNAME=$HOSTNAME"
[ -z "$QTV_PASSWORD" ] && export QTV_PASSWORD=""; echo " * QTV_PASSWORD=$QTV_PASSWORD"
echo " * ADMIN_PASSWORD=$(echo $ADMIN_PASSWORD | sed 's/./*/g')"

[ -z "$SERVER_IP" ] && {
  echo
  echo -n "Detecting external IP..."
  export ADDRESS=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')
  [ -z "$ADDRESS" ] && error "Could not detect external IP" || echo "OK ($ADDRESS)"
} || {
  export ADDRESS=$SERVER_IP; echo " * SERVER_IP=$SERVER_IP"
}

echo -n "Generating configuration files..."
envsubst < /qtv/qtv.cfg.template > /qtv/qtv.cfg || error "Could not configure QTV"
added=0
servers=$(echo $TARGET_SERVERS | tr "," "\n")
for server in $servers
do
  added=1
  echo "qtv $server" >> /qtv/qtv.cfg
done
[ "$added" = "0" ] && error "No target servers specified"
echo "OK"

echo
echo "Initialization complete!"
echo

echo "============== Starting QTV =============="
cd /qtv
./qtv.bin +exec qtv.cfg || error "Could not start QTV"
