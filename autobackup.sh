#!/bin/bash
# Author: vis21
# Version: 1.0

# Define variables for origin and destination directories
sourceDirs=("/var/www" "/etc/nginx")
destDir="/home/backups"
archiveDir="/home/backup-archive"

# Check if the directories exist and create if they don't
if [ ! -d "$sourceDirs" ]; then
    mkdir -p "$sourceDirs"
fi

if [ ! -d "$destDir" ]; then
    mkdir -p "$destDir"
fi

if [ ! -d "$archiveDir" ]; then
    mkdir -p "$archiveDir"
fi

# Function to copy source directories to the destination directory
backup() {
    echo "Copying source directories to the backup location..."
    if cp -R "$sourceDirs" "$destDir"; then
        echo "Successfully backed up source directories!"
    else
        echo "Failed to back up source directories."
    fi
}

# Compress backups taken more than 7 days ago
compress_backups() {
    echo "Compressing backups older than 7 days..."
    find "$destDir" -mindepth 1 -maxdepth 1 -type d -mtime +7 | while read -r dir; do
        archiveName="$archiveDir/$(basename "$dir").tar.gz"
        echo "Compressing $dir to $archiveName"
        if tar -czf "$archiveName" -C "$destDir" "$(basename "$dir")"; then
            echo "Successfully compressed $dir!"
            rm -rf "$dir"
        else
            echo "Failed to compress $dir."
        fi
    done
}

cleanup() {
    find "$archiveDir" -name "*.tar.gz" -type f -mtime +14 -exec rm {} \;
}

for dir in "${sourceDirs[@]}"; do
    backup "$dir" "$destDir"
done

compress_backups
cleanup
