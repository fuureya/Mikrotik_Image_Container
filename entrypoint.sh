#!/bin/bash

# Pastikan /dev/net/tun tersedia (jika sewaktu-waktu butuh TAP)
if [ ! -c /dev/net/tun ]; then
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
fi

# Jalankan QEMU
# Kita gunakan user-mode networking dengan hostfwd karena ini paling kompatibel dengan VPS (Host Mode).
# List Port yang diteruskan:
# 8291: Winbox
# 2222 -> 22: SSH
# 9865 -> 80: Webfig
# 443 -> 443: SSL
# 500/udp, 4500/udp, 1701/udp: L2TP/IPsec
# 1723: PPTP

exec qemu-system-x86_64 \
    -m 256 \
    -drive file=mikrotik_disk.qcow2,format=qcow2 \
    -netdev user,id=n1,\
hostfwd=tcp::8291-:8291,\
hostfwd=tcp::2222-:22,\
hostfwd=tcp::9865-:80,\
hostfwd=tcp::443-:443,\
hostfwd=udp::500-:500,\
hostfwd=udp::4500-:4500,\
hostfwd=udp::1701-:1701,\
hostfwd=tcp::1723-:1723 \
    -device e1000,netdev=n1 \
    -vnc :0 \
    -nographic
