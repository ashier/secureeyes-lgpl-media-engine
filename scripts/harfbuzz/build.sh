#!/bin/sh

set -e # exit immediately if a command exits with a non-zero status
set -u # treat unset variables as an error

cd ${SRC_DIR}

patch -p1 <${PROJECT_DIR}/patches/harfbuzz-fix-apple-sincosf.patch

# harfbuzz picks its CoreText backend on `host_machine.system() == 'darwin'`,
# and every cross-file here says darwin - iOS included, because ffmpeg derives
# its --target-os from that same value and only understands darwin. So on iOS
# harfbuzz takes the macOS path and links ApplicationServices, a framework the
# iOS SDKs do not have, and the link fails with undefined CoreText symbols.
# Nothing here needs harfbuzz's CoreText shaper: libass shapes with the
# built-in OpenType shaper, and CoreText font *lookup* happens inside libass.
CORETEXT=enabled
if [ "${OS}" != "macos" ]; then
    CORETEXT=disabled
fi

meson setup build \
    --buildtype=release \
    --cross-file ${PROJECT_DIR}/cross-files/${OS}-${ARCH}.ini \
    --prefix="${OUTPUT_DIR}" \
    -Dglib=disabled \
    -Dgobject=disabled \
    -Dcairo=disabled \
    -Dchafa=disabled \
    -Dicu=disabled \
    -Dgraphite=disabled \
    -Dgraphite2=disabled \
    -Dfreetype=disabled \
    -Dgdi=disabled \
    -Ddirectwrite=disabled \
    -Dcoretext=${CORETEXT} \
    -Dtests=disabled \
    -Dintrospection=disabled \
    -Ddocs=disabled \
    -Dbenchmark=disabled \
    -Dicu_builtin=false \
    -Dexperimental_api=false \
    -Dragel_subproject=false \
    -Dfuzzer_ldflags=
meson compile -C build
meson install -C build
