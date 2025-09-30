FROM archlinux:latest

RUN echo -e "\n\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" >> /etc/pacman.conf \
    && pacman -Syu --noconfirm && pacman -S --noconfirm \
    mingw-w64-gcc \
    glslang \
    git \
    make \
    pkgconf \
    gcc \
    lib32-gcc-libs \
    flex \
    bison \
    libunwind \
    lib32-libunwind \
    libx11 \
    lib32-libx11 \
    libxcomposite \
    lib32-libxcomposite \
    libxcursor \
    lib32-libxcursor \
    libxfixes \
    lib32-libxfixes \
    libxi \
    lib32-libxi \
    libxrandr \
    lib32-libxrandr \
    libxrender \
    lib32-libxrender \
    libxext \
    lib32-libxext \
    freetype2 \
    lib32-freetype2 \
    fontconfig \
    lib32-fontconfig \
    gnutls \
    lib32-gnutls \
    dbus \
    lib32-dbus \
    systemd \
    lib32-systemd \
    mesa \
    lib32-mesa \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    vulkan-headers \
    sdl2 \
    lib32-sdl2 \
    alsa-lib \
    lib32-alsa-lib \
    libpulse \
    lib32-libpulse \
    gstreamer \
    lib32-gstreamer \
    gst-plugins-base-libs \
    lib32-gst-plugins-base-libs
RUN useradd -m builder \
    && chmod 777 /home/builder

USER builder

WORKDIR /home/builder/source

ENV BUILD_MODE="tests"
ENV TARGET_LIB="d3d8"
ENV BUILD_X86_BITS=32

CMD ["bash", "-c", "/home/builder/source/wine_build.sh \"$TARGET_LIB\" $BUILD_X86_BITS"]

