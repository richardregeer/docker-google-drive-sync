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
    syncDrive(
      remote.name,
      remote.source || config.defaultSource || '/',
      remote.destination,
      remote.syncOptions || config.defaultSyncOptions || ''
    );
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

function syncDrive(remote, source, destination, syncOptions) {
  const driveLog = `${remote}:${source} to ${destination}`;
  console.log(`Sync files from: ${driveLog}`);

  shell.exec(`rclone sync ${remote}:${source} ${destination} ${syncOptions} -v --fast-list`);

  console.log(`Finished syncing files from: ${driveLog}`);
}

main();
