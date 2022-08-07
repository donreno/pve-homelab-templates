#!/bin/sh

#COMMON VARS
IMAGE="/root/focal-server-cloudimg-amd64.img"
IMAGE_URL="https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
SSH_KEY_FILE="/root/id_rsa.pub"
SCRIPT_NAME=$0
STORAGE=$1

#Small node variables
SMALL_ID=690
SMALL_NAME="ubuntu-srv-small"
SMALL_CORES=1
SMALL_MEMORY=512

#Medium node variables
MEDIUM_ID=691
MEDIUM_NAME="ubuntu-srv-mid"
MEDIUM_CORES=2
MEDIUM_MEMORY=512

#Big node variables
BIG_ID=692
BIG_NAME="ubuntu-srv-big"
BIG_CORES=4
BIG_MEMORY=1024

install_cloud_init() {
    apt-get install -y cloud-init
}

download_ubuntu_cloud_image() {
    if [ ! -f "$IMAGE" ]; then
        echo "Descargando Ubuntu focal cloud image"
        wget $IMAGE_URL
    else
        echo "Imagen ya esta descargada"
    fi
}

create_template() {
    local id=$1
    local name=$2
    local memory=$3
    local cores=$4

    qm create $id --memory $memory --core $cores --name $name --net0 virtio,bridge=vmbr0
    qm importdisk $id $IMAGE $STORAGE
    qm set $id --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$id-disk-0
    qm resize $id scsi0 +2G
    qm set $id --ide2 $STORAGE:cloudinit
    qm set $id --boot c --bootdisk scsi0
    qm set $id --serial0 socket --vga serial0
    qm set $id --sshkey $SSH_KEY_FILE
    qm template $id
}

usage() {
    echo "Debe indicar el almacenamiento. Por ejemplo: $SCRIPT_NAME local-lvm"
    exit 1
}

validate_storage_is_set() {
    if [ -z "$STORAGE" ]; then
        usage
    fi
}

validate_ssh_key() {
    if [ ! -f "$SSH_KEY_FILE" ]; then
        echo "SSH key no encontrada en $SSH_KEY_FILE"
        exit 1
    fi
}

main() {
    echo "Inicializando creacion de templates"
    install_cloud_init
    validate_storage_is_set
    validate_ssh_key
    download_ubuntu_cloud_image
    create_template $SMALL_ID $SMALL_NAME $SMALL_MEMORY $SMALL_CORES
    create_template $MEDIUM_ID $MEDIUM_NAME $MEDIUM_MEMORY $MEDIUM_CORES
    create_template $BIG_ID $BIG_NAME $BIG_MEMORY $BIG_CORES
    echo "Completado exitosamente!"
}

main
