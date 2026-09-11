#!/usr/bin/env bash

set -e

shopt -s extglob

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 version destdir [--no-package] [--dev-build]"
  exit 1
fi

D3D9TO8_VERSION="$1"
D3D9TO8_SRC_DIR=$(readlink -f "$0")
D3D9TO8_SRC_DIR=$(dirname "$D3D9TO8_SRC_DIR")
D3D9TO8_BUILD_DIR=$(realpath "$2")"/d3d9to8-$D3D9TO8_VERSION"
D3D9TO8_ARCHIVE_PATH=$(realpath "$2")"/d3d9to8-$D3D9TO8_VERSION.tar.gz"

if [ -e "$D3D9TO8_BUILD_DIR" ]; then
  echo "Build directory $D3D9TO8_BUILD_DIR already exists"
  exit 1
fi

shift 2

opt_nopackage=0
opt_devbuild=0
opt_buildid=false
opt_64_only=0
opt_32_only=0

crossfile="build-win"

while [ $# -gt 0 ]; do
  case "$1" in
  "--no-package")
    opt_nopackage=1
    ;;
  "--dev-build")
    opt_nopackage=1
    opt_devbuild=1
    ;;
  "--build-id")
    opt_buildid=true
    ;;
  "--64-only")
    opt_64_only=1
    ;;
  "--32-only")
    opt_32_only=1
    ;;
  *)
    echo "Unrecognized option: $1" >&2
    exit 1
  esac
  shift
done

function build_arch {
  export WINEARCH="win$1"
  export WINEPREFIX="$D3D9TO8_BUILD_DIR/wine.$1"

  cd "$D3D9TO8_SRC_DIR"

  opt_strip=
  if [ $opt_devbuild -eq 0 ]; then
    opt_strip=--strip
  fi

  meson setup --cross-file "$D3D9TO8_SRC_DIR/$crossfile$1.txt" \
        --buildtype "release"                                  \
        --prefix "$D3D9TO8_BUILD_DIR"                          \
        $opt_strip                                             \
        --bindir "x$1"                                         \
        --libdir "x$1"                                         \
        "$D3D9TO8_BUILD_DIR/build.$1"

  cd "$D3D9TO8_BUILD_DIR/build.$1"
  ninja install

  if [ $opt_devbuild -eq 0 ]; then
    # get rid of some useless .a files
    rm "$D3D9TO8_BUILD_DIR/x$1/"*.!(dll)
    rm -R "$D3D9TO8_BUILD_DIR/build.$1"
  fi
}

function package {
  cd "$D3D9TO8_BUILD_DIR/.."
  tar -czf "$D3D9TO8_ARCHIVE_PATH" "d3d9to8-$D3D9TO8_VERSION"
  rm -R "d3d9to8-$D3D9TO8_VERSION"
}

if [ $opt_32_only -eq 0 ]; then
  build_arch 64
fi
if [ $opt_64_only -eq 0 ]; then
  build_arch 32
fi

if [ $opt_nopackage -eq 0 ]; then
  package
fi
