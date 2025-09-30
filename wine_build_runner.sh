#!/bin/bash

# build locally or trigger remote builds via ssh
LOCAL_BUILD=true
REMOTE_HOST="ssh://127.0.0.1"
# relative paths that need to be absolute when building remotely
SOURCE_PATH="$PWD/source"
OUTPUT_PATH="$PWD/output"
BUILD_MODE="tests"
# update if you care about file timestamps
TIMEZONE="Etc/UTC"

if [ ! -d "$SOURCE_PATH" ]
then
    echo "Specified source path is invalid!"
    exit 1
fi

if [ ! -d "$OUTPUT_PATH" ]
then
    echo "Specified output path is invalid!"
    exit 2
fi

if [ $# -ge 1 ]
then
    TARGET_LIB="$1"

    if [ $# -ge 2 ]
    then
        if [ $2 -eq 32 -o $2 -eq 64 ]
        then
            BUILD_X86_BITS=$2
        else
            echo "Invalid parameters: unsupported x86 bit value of $2!"
            exit 4
        fi
    else
        # build 64-bit tests by default,
        # change to 32 to build for i686
        BUILD_X86_BITS=64
    fi

    if $LOCAL_BUILD
    then
        docker run -ti --rm \
                   --name archmage-builder \
                   -h archmage-builder \
                   -e TZ="$TIMEZONE" \
                   -e BUILD_MODE="$BUILD_MODE" \
                   -e TARGET_LIB="$TARGET_LIB" \
                   -e BUILD_X86_BITS=$BUILD_X86_BITS \
                   -v "$SOURCE_PATH":/home/builder/source \
                   -v "$OUTPUT_PATH":/home/builder/output \
                   archmage-builder:wine
    else
        docker -H "$REMOTE_HOST" run -ti --rm \
                   --name archmage-builder \
                   -h archmage-builder \
                   -e TZ="$TIMEZONE" \
                   -e BUILD_MODE="$BUILD_MODE" \
                   -e TARGET_LIB="$TARGET_LIB" \
                   -e BUILD_X86_BITS=$BUILD_X86_BITS \
                   -v "$SOURCE_PATH":/home/builder/source \
                   -v "$OUTPUT_PATH":/home/builder/output \
                   archmage-builder:wine
    fi
else
    echo "Invalid parameters: please specify the target lib!"
    exit 3
fi

