# docker-google-drive-sync
This docker image uses rclone to continuously sync your google drive data to a specific directory. It's also possible to sync changes back to google drive.

## Howto use the container
```bash
docker run --rm \
--log-opt max-size=10m \
-v <host/path/to/offline/folder>:/var/target \
-v <host/path/to/config/folder>:/root/.config/rclone \
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
Environment variables can be set:
- `DRIVE_SYNC_FOLDER`: Default '/'
- `TARGET_FOLDER`: Default /var/target
- `REPEAT`: Default 60s
- `DRIVE_NAME`: Default google-drive
- `SYNC_OPTIONS` Default none
- `BI_DIRECTIONAL_SYNC` Default FALSE

For more info about rclone configuration see the [rclone](https://rclone.org/drive/) documentation.
```bash
# Use -e to override the environment variable.
docker run --rm \
--log-opt max-size=10m \
-e DRIVE_SYNC_FOLDER=/test \
-e TARGET_FOLDER=/var/other/target \
-e REPEAT=120 \
-e DRIVE_NAME=drive-example \
-e SYNC_OPTIONS=-L \
-e BI_DIRECTIONAL_SYNC=TRUE \
-v <host/path/to/offline/folder>:/var/target \
-v <host/path/to/config/folder>:/root/.config/rclone \
-d \
richardregeer/google-drive-sync
```
