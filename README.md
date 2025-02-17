# autobackup
## Description
Simple bash script written to back up more than one directory, compress the backups over time and remove any old compressed backups, which are no longer relevant. Directories requiring backups can be specified in the "sourceDirs" array like this:
```
sourceDirs=("/var/www" "/etc/nginx")
```
just like destination of the backups can be specified in "destDir" variable:
```
destDir="/home/backups"
```
and destination for compressed backups in "archiveDir" variable:
```
archiveDir="/home/backup-archive"
```

The above are example paths, so please set them accordingly to your needs. The time after which backups are compressed and compressed backups are removed can both be changed based on your requirements too.

To change when backups are compressed change -mtime value (i.e. from +7 to +10) in the following line:
```
oldBackups=$(find "$destDir" -mindepth 1 -maxdepth 1 -type d -mtime +7)
```
and to adjust when compressed backups are removed change -mtime value (i.e. from +14 to +20) in the cleanup function:
```
oldArchives=$(find "$archiveDir" -name "*.tar.gz" -type f -mtime +14)
```

If you're not aware how the -mtime is calculated, please refer to the relevant man page.

This script was tested and deployed to Ubuntu 22.04 environment and worked without any issues with multiple directories specified. However, if you do come across any issues or have any ideas how it could be improved, then please let me know.
