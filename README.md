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
  "defaultSource": "/",
  "defaultSyncOptions": "",
  "syncInterval": 60000,
  "remotes": [
    {
      "source": "/test-1",
      "name": "google-drive-1",
      "destination": "/var/target"
    },
    {
      "source": "/test-2",
      "name": "google-drive-2",
      "destination": "/var/target",
      "syncLocalToRemote": true
    }
  ]
}
```
- defaultSource: Default '/' (optional). The default folder within google drive to sync.
- defaultSyncOptions: Default none (optional). Add additional rclone arguments, for more info about rclone configuration see the [rclone](https://rclone.org/drive/) documentation.
- syncInterval: Default 60000. The amount of time in mili seconds between syncs.
- runOnce: Default false. When set to true the sync will run only one time and then exit.
- remotes: At least one is required. Contains the configuration of the remotes in a collection.
  - name: The configuration name of remote, must be the same as in rclone.conf.
  - source: Default '/' (optional). The default folder within google drive to sync.
  - destination: The folder where the google-drive files are synced in the container. Make sure this folder is a volume that is shared with the host.
  - syncOptions: Default none (optional). Add additional rclone arguments, for more info about rclone configuration see the [rclone](https://rclone.org/drive/) documentation.
  - syncLocalToRemote: Default false. Reverse the sync from remote drive to local, so your local sync folder is leading. This options can be useful if you want to use the webdrive as backup.

It is possible to add multiple remotes. Make sure you also add the remote rclone configuration in the ``rclone.conf`` file with the same name as in the ``config.json``. The remotes will be synced in sequence and in order of the config.json.

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
