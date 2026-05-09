#!/bin/bash

# NOTE: this needs to be run as root

# validate parameters
if [ "$#" -ne 2 ]; then
    echo "error: wrong number of parameters"
    echo "usage: ./backup.sh [SRC] [DEST]"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "error: couldn't find input file"
    exit 1
fi

# validate input paths
error=false
echo "checking paths..."

while IFS= read -r path; do
    if [ "$path" != "" ] && [ ! -e "$path" ]; then
        echo "error: path '$path' not found"
        error=true
    fi
done < "$1"

if [ $error = true ]; then
    exit 1
fi

# read disk usage of paths
concat=""

# build a single string with literal quotation marks around
# each path so du doesn't break if any paths have spaces
while IFS= read -r path; do
    if [ "$path" != "" ]; then
        concat="$concat \"$path\""
    fi
done < "$1"

echo "$concat" | xargs du -shc

# ask the user if they want to continue
echo "are you sure you want to back up the paths in '$1' to '$2'? (y/N)"

while [ true ]; do
    read continue

    case $continue in
        'n' | 'N' | '') exit 0 ;;
        'y' | 'Y') break ;;
        *) echo 'invalid input' ;;
    esac
done

# create output directory if necessary
if [ ! -d "$2" ]; then
    mkdir "$2"
fi

# perform backup
echo 'backup starting...'
rsync -ravUh --delete-during --files-from="$1" / "$2"
