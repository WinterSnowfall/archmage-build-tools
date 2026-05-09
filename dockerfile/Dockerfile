FROM archlinux:latest

RUN echo -e "\n\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" >> /etc/pacman.conf \
    && pacman -Syu --noconfirm && pacman -S --noconfirm \
    mingw-w64-toolchain \
    gcc \
    meson \
    pkgconf \
    cmake \
    make \
    glslang \
    wine \
    sdl2 \
    sdl3 \
    git
RUN useradd -m builder \
    && chmod 777 /home/builder

USER builder

WORKDIR /home/builder/source

ENV REPO_NAME="dxvk"
ENV BUILD_NAME="devel"
ENV BUILD_TYPE="regular"
ENV BUILD_VARIANT="default"

CMD ["bash", "-c", "/home/builder/source/repo_build.sh \"$REPO_NAME\" \"$BUILD_NAME\" \"$BUILD_TYPE\" \"$BUILD_VARIANT\""]

