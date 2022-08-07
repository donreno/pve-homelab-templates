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

Luego descargamos el script y damos permisos para ejecutar

```sh
$ wget https://raw.githubusercontent.com/donreno/pve-homelab-templates/main/initialize-templates.sh
$ chmod +x initialize-templates.sh
```

Finalmente ejecutamos el script indicando el almacenamiento, usuario y password:

```sh
$ ./initialize-templates.sh local-lvm awesomeuser AwesomePassword
```

Listo con esto finalmente tendremos creadas 3 plantillas de cloud image para proxmox VE:

- **ubuntu-srv-small**: 1 Core / 512mb
- **ubuntu-srv-mid**: 2 Cores / 1024mb
- **ubuntu-srv-big**: 4 Cores / 2048mb
