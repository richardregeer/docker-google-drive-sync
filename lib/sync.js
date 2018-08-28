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

const driveLog = `${config.googleDriveName}:${config.googleDriveSyncFromFolder} to ${config.syncToLocalFolder}`;

function main() {
  console.log('Start google drive sync');
  console.log(`Sync files from drive ${driveLog}`);

  shell.exec(`rclone sync ${config.googleDriveName}:${config.googleDriveSyncFromFolder} ${config.syncToLocalFolder} ${config.syncOptions} -v --fast-list`);

  console.log(`Finished syncing files from ${driveLog}`);

  setTimeout(main, config.syncInterval);
}

main();
