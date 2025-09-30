FROM registry.gitlab.steamos.cloud/steamrt/sniper/sdk:latest

RUN useradd -m builder \
    && chmod 777 /home/builder

USER builder

WORKDIR /home/builder/source

ENV REPO_NAME="dxvk"
ENV BUILD_NAME="devel"
ENV BUILD_TYPE="native"
ENV BUILD_VARIANT="sniper"

CMD ["bash", "-c", "/home/builder/source/repo_build.sh \"$REPO_NAME\" \"$BUILD_NAME\" \"$BUILD_TYPE\" \"$BUILD_VARIANT\""]

