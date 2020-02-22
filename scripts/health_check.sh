#!/bin/sh

error() {
  echo "ERROR: $1"
}

external_ip=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')
[ "$ADDRESS" != "$external_ip" ] && error "External IP has changed, please restart this container"

curl -f http://localhost:28000 || error "Could not reach QTV website"

exit 0
