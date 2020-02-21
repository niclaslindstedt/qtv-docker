#!/bin/sh

echo "Configuring QTV..."
envsubst < /qtv/qtv.cfg.template > /qtv/qtv.cfg

echo "Starting QTV"
cd /qtv
./qtv.bin
