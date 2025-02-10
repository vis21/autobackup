#!/bin/bash
# Author: vis21
# Version: 1.0

# Define variables for origin and destination directories
sourceDirs=("/var/www" "/etc/nginx")
destDir="/home/backups"
archiveDir="/home/backup-archive"

# Check if the directories exist and create if they don't
if [ ! -d "$sourceDirs" ]; then
    echo "Source directories don't exist, please specfiy correct directories to back up."
    exit 1
fi

if [ ! -d "$destDir" ]; then
    mkdir -p "$destDir"
fi

if [ ! -d "$archiveDir" ]; then
    mkdir -p "$archiveDir"
fi

# Function to copy source directories to the destination directory
backup() {
    for dir in "${sourceDirs[@]}"; do
        echo "Copying source directory $dir to destination directory $destDir"
        if cp -r "$dir/" "$destDir"; then
            echo "Successfully backed up $dir"
        else
            echo "Failed to back up $dir"
        fi
    done
}

# Compress backups taken more than 7 days ago
compress_backups() {
    echo "Checking for backups older than 7 days..."
    if [ -z "$(find "$destDir" -mindepth 1 -maxdepth 1 -type d -mtime +1)" ]; then
        echo "No backups available for compression"
    else
        echo "Compressing backups older than 7 days..."
        while read -r dir; do
            archiveName="$archiveDir/$(basename "$dir").tar.gz"
            echo "Compressing $dir to $archiveName"
            if tar -czf "$archiveName" -C "$destDir" "$(basename "$dir")"; then
                echo "Successfully compressed $dir"
                rm -rf "$dir"
            else
                echo "Failed to compress $dir"
            fi
        done
    fi
}

cleanup() {
    find "$archiveDir" -name "*.tar.gz" -type f -mtime +2 -exec rm {} \;
}

backup
compress_backups
cleanup
