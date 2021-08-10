#!/bin/bash

set -e

case "$1" in
    build)
        # The latest version is usually linked from this topic
        # on the Lexaloffle BBS: https://www.lexaloffle.com/bbs/?tid=34009
        PICO_VERSION="$2"
        VERSION_SUFFIX="chip"
        ARCH="armhf"
        ZIP_NAME="pico-8_${PICO_VERSION}_${VERSION_SUFFIX}.zip"

        DIST_PATH="./chip-pico-8_${PICO_VERSION}.${VERSION_SUFFIX}.${ARCH}/"

        cp -R ./deb-src "${DIST_PATH}"

        PICO_PATH="${DIST_PATH}usr/lib"

        # Grab the zip and extract it
        wget -nc "www.lexaloffle.com/dl/chip/${ZIP_NAME}"
        mkdir -p "${PICO_PATH}"
        unzip "${ZIP_NAME}" -d "${PICO_PATH}"

        # Update the Version in the control file to reflect the current version
        sed -i "s|Version: .*|Version: ${PICO_VERSION}.${VERSION_SUFFIX}|" "${DIST_PATH}DEBIAN/control"

        # fix permissions
        sudo chown -R 0:0 "${DIST_PATH}"
        sudo chmod 0775 "${DIST_PATH}/DEBIAN/preinst"
        sudo chmod 0775 "${DIST_PATH}/DEBIAN/postinst"
        sudo chmod +x "${DIST_PATH}/bin/pico8"

        # build the deb
        dpkg -b "${DIST_PATH}"
    ;;
    *)
        echo "Usage: ./build-package.sh build 0.2.2c" >&2
        exit 1
    ;;
esac

exit 0