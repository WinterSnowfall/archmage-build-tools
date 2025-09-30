FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
    && apt-get update && apt-get install -y --no-install-recommends \
    mingw-w64 \
    gcc \
    pkgconf \
    cmake \
    make \
    glslang-tools \
    wine \
    git \
    python3 \
    python3-pip \
    && pip3 install meson ninja \
    # cleanup post meson/ninja install to reduce final image size
    && apt-get remove -y python3-pip \
    && apt-get autoremove -y
RUN useradd -m builder \
    && chmod 777 /home/builder

USER builder

WORKDIR /home/builder/source

ENV REPO_NAME="dxvk-tests"
ENV BUILD_NAME="devel"
ENV BUILD_TYPE="regular"
ENV BUILD_VARIANT="xp"

CMD ["bash", "-c", "/home/builder/source/repo_build.sh \"$REPO_NAME\" \"$BUILD_NAME\" \"$BUILD_TYPE\" \"$BUILD_VARIANT\""]

