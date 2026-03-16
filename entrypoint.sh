#!/bin/bash

# Pastikan /dev/net/tun tersedia (jika sewaktu-waktu butuh TAP)
if [ ! -c /dev/net/tun ]; then
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
fi

# Jalankan QEMU dengan user-mode networking.
# hostfwd di sini memetakan port dari Container ke VM Mikrotik.
# Docker memetakan port dari Host ke Container.

exec qemu-system-x86_64 \
    -m 256 \
    -drive file=mikrotik_disk.qcow2,format=qcow2 \
    -netdev user,id=n1,\
hostfwd=tcp::8291-:8291,\
hostfwd=tcp::22-:22,\
hostfwd=tcp::80-:80,\
hostfwd=tcp::443-:443,\
hostfwd=udp::500-:500,\
hostfwd=udp::4500-:4500,\
hostfwd=udp::1701-:1701,\
hostfwd=tcp::1723-:1723 \
    -device e1000,netdev=n1 \
    -vnc :0 \
    -nographic
