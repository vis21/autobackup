#!/bin/bash
# Author: vis21
# Version: 1.0

# Get current date
curDate=$(date +"%Y-%m-%d_%H:%M:%S")

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
        if cp -r "$dir/" "$destDir/$(basename "$dir")_${curDate}"; then
            echo "Successfully backed up $dir"
        else
            echo "Failed to back up $dir"
        fi
    done
}

# Compress old backups
compress_backups() {
    oldBackups=$(find "$destDir" -mindepth 1 -maxdepth 1 -type d -mtime +7)
    echo "Checking for older backups..."
    if [ -z "$oldBackups" ]; then
        echo "No backups available for compression"
    else
        echo "Compressing older backups..."
        echo "$oldBackups" | while read -r dir; do
            archiveName="$archiveDir/$(basename "$dir").tar.gz"
            echo "Compressing $dir to $archiveName"
            if tar -czf "$archiveName" -C "$destDir" "$(basename "$dir")"; then
                echo "Successfully compressed $dir"
                rm -rf "$dir"
                echo "Successfully removed $dir"
            else
                echo "Failed to compress $dir"
            fi
        done
    fi
}

# Clean up old archives
cleanup() {
    echo "Checking for older archives..."
    oldArchives=$(find "$archiveDir" -name "*.tar.gz" -type f -mtime +14)
    if [ -z "$oldArchives" ]; then
        echo "No archives available for deletion"
    else
        echo "Deleting the old archives:"
        echo "$oldArchives"
        rm -rf $oldArchives
        echo "Successfully deleted old archives"
    fi
}

backup
compress_backups
cleanup
