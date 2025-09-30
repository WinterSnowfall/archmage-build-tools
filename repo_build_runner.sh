#!/bin/bash

# build locally or trigger remote builds via ssh
LOCAL_BUILD=true
REMOTE_HOST_IP="127.0.0.1"
# use rsync to push sources to the remote host
# and retrive binaries post-build
USE_RSYNC=false
DOCKER_IMAGE_TAG=":latest"
# relative paths that need to be absolute when building remotely
SOURCE_PATH="$PWD/source"
OUTPUT_PATH="$PWD/output"
MISC_PATH="$PWD/misc"
BUILD_NAME="devel"
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

if [ ! -d "$MISC_PATH" ]
then
    echo "Specified misc path is invalid!"
    exit 3
fi

if [ $# -ge 1 ]
then
    REPO_NAME="$1"

    if [ $# -ge 2 ]
    then
        if [ "$2" == "--native" -o "$3" == "--native" ]
        then
            BUILD_TYPE="native"

            if [ "$2" == "--native" -a $# -ge 3 ]
            then
                BUILD_NAME="$3"
            elif [ "$3" == "--native" ]
            then
                BUILD_NAME="$2"
            fi
        else
            BUILD_TYPE="regular"
            BUILD_NAME="$2"
        fi
    fi

    if $LOCAL_BUILD
    then
        docker run -ti --rm \
                   --name archmage-builder \
                   -h archmage-builder \
                   -e TZ="$TIMEZONE" \
                   -e REPO_NAME="$REPO_NAME" \
                   -e BUILD_NAME="$BUILD_NAME" \
                   -e BUILD_TYPE="$BUILD_TYPE" \
                   -v "$SOURCE_PATH":/home/builder/source \
                   -v "$OUTPUT_PATH":/home/builder/output \
                   -v "$MISC_PATH":/home/builder/misc \
                   archmage-builder"$DOCKER_IMAGE_TAG"
    else
        if $USE_RSYNC
        then
            echo "Syncing source path to remote host..."
            rsync -av -P --checksum --mkpath --delete -e ssh "$SOURCE_PATH/$REPO_NAME/" "$REMOTE_HOST_IP:$SOURCE_PATH/$REPO_NAME/"
            if [ $? -ne 0 ]
            then
                echo "Error encountered during source path syncing."
                exit 5
            fi
            echo -e "Syncing complete.\n"
        fi

        docker -H "ssh://$REMOTE_HOST_IP" run -ti --rm \
                   --name archmage-builder \
                   -h archmage-builder \
                   -e TZ="$TIMEZONE" \
                   -e REPO_NAME="$REPO_NAME" \
                   -e BUILD_NAME="$BUILD_NAME" \
                   -e BUILD_TYPE="$BUILD_TYPE" \
                   -v "$SOURCE_PATH":/home/builder/source \
                   -v "$OUTPUT_PATH":/home/builder/output \
                   -v "$MISC_PATH":/home/builder/misc \
                   archmage-builder"$DOCKER_IMAGE_TAG"

        if $USE_RSYNC
        then
            echo -e "\nRetrieving binaries from remote host..."
            rsync -av -P --checksum --mkpath --delete -e ssh "$REMOTE_HOST_IP:$OUTPUT_PATH/$REPO_NAME-$BUILD_NAME/" "$OUTPUT_PATH/$REPO_NAME-$BUILD_NAME/"
            if [ $? -ne 0 ]
            then
                echo "Error encountered during binary retrieval."
                exit 6
            fi
            echo "Retrieval complete"
        fi
    fi
else
    echo "Please specify the repository name!"
    exit 4
fi

