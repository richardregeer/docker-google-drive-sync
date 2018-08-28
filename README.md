# docker-google-drive-sync
[![Build Status](https://travis-ci.org/richardregeer/docker-google-drive-sync.svg?branch=master)](https://travis-ci.org/richardregeer/docker-google-drive-sync)

This docker image uses rclone to continuously sync your google drive data to a specific directory. It's also possible to sync changes back to google drive.

## Howto use the container
```bash
docker run --rm \
--log-opt max-size=10m \
-v <host/path/to/offline/folder>:/var/target \
-v <host/path/to/rclone-config/folder>:/root/.config/rclone \
-d \
richardregeer/google-drive-sync
```

A rclone configuration can be created by running the config command. Make sure you answer 'N' on the autoconfig option. It will give an URL that you can open open in your browser.
When you created the config copy it and create a shared volume to use the configuration in the container. For more information howto create rclone configuration see the [rclone](https://rclone.org/drive/) documentation.

Run the following command to run the rclone configuration in a docker container.
```bash
docker run --rm -it \
richardregeer/google-drive-sync \
bash -c 'rclone config && echo -e "\n\n****[ Config file]****" && cat /root/.config/rclone/rclone.conf'
```

## Configuration options
```json
{
  "googleDriveSyncFromFolder": "/",
  "googleDriveName": "google-drive",
  "syncToLocalFolder": "/var/target",
  "syncOptions": "",
  "syncInterval": 60000
}
```
- googleDriveSyncFromFolder: Default '/'. The folder within google drive to sync.
- googleDriveName: Default google-drive. The name used in rclone.
- syncToLocalFolder: Default /var/target. The folder where the google-drive files are synced in the container. Make sure this folder is a volume that is shared with the host.
- syncOptions: Default none. Add additional rclone arguments, for more info about rclone configuration see the [rclone](https://rclone.org/drive/) documentation.
- syncInterval: Default 60000. The amount of time in mili seconds between syncs.

```bash
# Use -v to override the default config.json configuration.
# Make sure to target the correct directory in the container.

docker run --rm \
--log-opt max-size=10m \
-v <host/path/to/google-sync-config.json>:/usr/local/bin/google-sync/etc/config.json
-v <host/path/to/offline/folder>:/var/target \
-v <host/path/to/config/folder/rclone.conf>:/root/.config/rclone/rclone.conf \
-d \
richardregeer/google-drive-sync
```

## Development
For development please use ``make`` to see the available tasks
```bash
# Show all the available tasks
make

# Install and build the environment
make install

# Start in development mode
make start
```
