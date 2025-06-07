FROM alpine:latest

RUN apk update && \
    apk add --no-cache qemu qemu-system-x86_64 qemu-img bash curl unzip

WORKDIR /app

# Download CHR VMDK zip
RUN curl -L -o chr.vmdk.zip https://download.mikrotik.com/routeros/7.19.1/chr-7.19.1.vmdk.zip

# Extract & convert
RUN unzip chr.vmdk.zip && \
    qemu-img convert -f vmdk -O qcow2 chr-*.vmdk mikrotik_disk.qcow2 && \
    rm chr-*.vmdk chr.vmdk.zip

CMD ["qemu-system-x86_64", \
     "-m", "256", \
     "-drive", "file=mikrotik_disk.qcow2,format=qcow2", \
     "-netdev", "user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::8291-:8291", \
     "-device", "e1000,netdev=n1", \
     "-vnc", ":0", \
     "-nographic"]
