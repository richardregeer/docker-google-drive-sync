'use strict';

const fs = require('fs');
const shell = require('shelljs');
const config = require('../etc/config.json');

const CONFIG_FILE = '/root/.config/rclone/rclone.conf';
const CONFIG_FILE_EXAMPLE = '/root/.config/rclone/rclone.conf.example';

if (!fs.existsSync(CONFIG_FILE)) {
  console.log(`Cannot find "${CONFIG_FILE}". An example configuration can be found in "${CONFIG_FILE_EXAMPLE}".`);
  shell.exit(1);
}

function main() {
  console.log('Start google drive sync.');

  if (!config.remotes) {
    console.log('No remotes found to sync.');
    shell.exit(1);
  }

  config.remotes.forEach((remote) => {
    validateRemote(remote);

    const source = remote.source || config.defaultSource || '/';
    const syncOptions = remote.syncOptions || config.defaultSyncOptions || '';

    if (remote.syncLocalToRemote) {
      syncLocalToRemote(
        remote.name,
        remote.destination,
        source,
        syncOptions
      );
    } else {
      syncRemoteToLocal(
        remote.name,
        source,
        remote.destination,
        syncOptions
      );
    }
  });

  setTimeout(main, config.syncInterval);
}

function validateRemote(remote) {
  if (!remote.name) {
    console.log('No name found for the remote.');
    shell.exit(1);
  }

  if (!remote.destination) {
    console.log(`No distination found for remote ${remote.name}.`);
    shell.exit(1);
  }
}

function syncRemoteToLocal(remote, source, destination, syncOptions) {
  console.log(`Sync files from remote ${remote}:${source} to local ${destination}`);

  shell.exec(`rclone sync ${remote}:${source} ${destination} ${syncOptions} -v`);

  console.log(`Finished syncing files to local ${destination}`);
}

function syncLocalToRemote(remote, source, destination, syncOptions) {
  shell.exec(`rclone sync ${source} ${remote}:${destination} ${syncOptions} -v`);

  console.log(`Finished syncing files to remote ${remote}:${destination}`);
}

main();
