#!/bin/bash
# Author: vis21
# Version: 1.0

# Define variables for origin and destination directories
sourceDirs=("/var/www" "/etc/nginx")
destDir="/home/backups/"

# Check if the destination directories exist and create if they don't
if [ ! -d "$sourceDirs" ]; then
    mkdir -p "$sourceDirs"
fi

if [ ! -d "$destDir" ]; then
    mkdir -p "$destDir"
fi

# Function to copy source directories to the destination directory
backup() {
    echo "Copying source directories to the backup location..."
    cp -R "$sourceDirs" "$destDir"
    if [ $? -eq 0 ]; then
        echo "Successfully backed up source directories!"
    else
        echo "Failed to back up source directories."
    fi
}

for dir in "${sourceDirs[@]}"; do
    backup "$dir" "$destDir"
done
