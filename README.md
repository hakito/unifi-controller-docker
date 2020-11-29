# unifi-controller-docker

Unifi Network Controller

Run the container on your host interface, otherwise it can't find your devices.

```bash
docker run -d --network=host hakito/unifi
```

## Backup and Restore scripts

To use the _backup.sh_ and _restore_ scripts clone this repository and download the [unifi api shell script](https://dl.ui.com/unifi/6.0.36/unifi_sh_api). Rename it to _unifi.sh_.

Adapt the _config.sh_ to your needs.

### Backup

Calling _backup.sh_ will download the current config.

### Restore

After starting the docker container wait, until the webinterface is reachable. The _restore.sh_ takes one argument with the path to the backup file.

```bash
restore.sh your-backup.unf
```
