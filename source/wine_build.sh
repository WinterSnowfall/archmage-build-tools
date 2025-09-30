#!/bin/bash

# set this env variable to any other value if you want to build the actual wine lib
if [ -z "$BUILD_MODE" ]
then
    BUILD_MODE="tests"
fi

if [ $# -ge 2 ]
then
    SOURCE_PATH="$PWD"
    OUTPUT_FOLDER="wine-$BUILD_MODE"
    TARGET_LIB="$1"
    BUILD_X86_BITS=$2

    if [ ! -d "$SOURCE_PATH/wine" ]
    then
        # speed up things by doing a shallow clone
        git clone --depth 1 --recurse-submodules https://github.com/wine-mirror/wine.git wine
    fi

    if [ -d "wine/dlls/$TARGET_LIB" ]
    then
        cd wine

        if [ $BUILD_X86_BITS -eq 64 ]
        then
            BUILD_DIR="x86_64-windows"
            ./configure --enable-win64
        elif [ $BUILD_X86_BITS -eq 32 ]
        then
            BUILD_DIR="i386-windows"
            # largely enough for minimal builds on x86-64 multi-lib
            ./configure --without-freetype
        else
            echo "Invalid parameters: unsupported x86 bit value of $BUILD_X86_BITS!"
            exit 3
        fi

        mkdir -p "$SOURCE_PATH/../output/$OUTPUT_FOLDER/x$BUILD_X86_BITS" 2>/dev/null

        # build the actual wine lib by default
        if [ "$BUILD_MODE" = "libs" ]
        then
            # cleanup the output directory, if any former artifacts were created
            rm -f "$SOURCE_PATH/../output/$OUTPUT_FOLDER/x$BUILD_X86_BITS/$TARGET_LIB".dll 2>/dev/null

            cd "dlls/$TARGET_LIB"
            make

            cp "$BUILD_DIR/$TARGET_LIB".dll "$SOURCE_PATH/../output/$OUTPUT_FOLDER/x$BUILD_X86_BITS"
        # fallback to building tests otherwise
        else
            if [ -d "dlls/$TARGET_LIB/tests" ]
            then
                # cleanup the output directory, if any former artifacts were created
                rm -f "$SOURCE_PATH/../output/$OUTPUT_FOLDER/x$BUILD_X86_BITS/$TARGET_LIB"_test.exe 2>/dev/null

                cd "dlls/$TARGET_LIB/tests"
                # will fail post-compilation, during test run,
                # since it won't find a wineserver binary
                make test 2>/dev/null

                cp "$BUILD_DIR/$TARGET_LIB"_test.exe "$SOURCE_PATH/../output/$OUTPUT_FOLDER/x$BUILD_X86_BITS"
            else
                echo "Invalid parameters: specified target lib does not contain tests!"
                exit 3
            fi
        fi

        cd "$SOURCE_PATH/wine"
        make clean
        cd ..
        # uncomment if you want to remove the source wine dir
        #rm -rf wine
    else
        echo "Invalid parameters: specified target lib does not exist!"
        exit 2
    fi
else
    echo "Invalid parameters: please specify the target lib and architecture!"
    exit 1
fi

