# pve-homelab-templates

Scripts para configurar mis templates pve

## Modo de uso

Antes de empezar debemos copiar nuestra SSH Key en Proxmox.

```sh
$ scp ~/.ssh/id_rsa.pub root@<PVE-IP>:/root/id_rsa.pub
```

Luego debes ingresar a PVE por ssh

```sh
$ ssh root@<PVE-IP>
```

Luego descargamos el script

```sh
wget https://raw.githubusercontent.com/donreno/pve-homelab-templates/main/initialize-templates.sh
```

Finalmente ejecutamos el script indicando el almacenamiento:

```sh
$ ./initialize-templates.sh local-lvm
```

Listo con esto finalmente tendremos creadas 3 plantillas de cloud image para proxmox VE:

- **ubuntu-srv-small**: 1 Core / 512mb
- **ubuntu-srv-mid**: 2 Core / 1024mb
- **ubuntu-srv-big**: 4 Core / 2048mb
