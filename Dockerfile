FROM alpine:latest

RUN apk update && \
    apk add --no-cache qemu qemu-system-x86_64 qemu-img bash curl unzip iproute2

WORKDIR /app

# Download CHR VMDK zip
RUN curl -L -o chr.vmdk.zip https://download.mikrotik.com/routeros/7.19.1/chr-7.19.1.vmdk.zip

# Extract & convert
RUN unzip chr.vmdk.zip && \
    qemu-img convert -f vmdk -O qcow2 chr-*.vmdk mikrotik_disk.qcow2 && \
    rm chr-*.vmdk chr.vmdk.zip

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
