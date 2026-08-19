#!/bin/sh

set -e # exit immediately if a command exits with a non-zero status
set -u # treat unset variables as an error

cd ${SRC_DIR}

# -Dpng is disabled deliberately. libpng 1.6.40 arrives as a meson subproject
# downloaded at setup time, and its pngpriv.h takes a Classic Mac OS branch
# whenever TARGET_OS_MAC is defined, including <fp.h> - a header that has not
# existed in twenty years. Patching a transitively downloaded subproject on
# every build is not worth what png support buys freetype here: decoding PNG
# bitmaps embedded in colour emoji fonts. Vector glyph rendering, which is all
# mpv and libass actually do for OSD and subtitle text, is unaffected. This
# also drops Png16 from the shipped bundle.
#
# zlib is internal rather than external for a cross-compilation reason: meson
# resolves an external zlib against the build machine, so the iOS simulator
# build linked the macOS SDK's libz.tbd and ld refused it ("building for
# iOS-simulator, but linking in dylib built for macOS"). freetype ships its own
# copy in src/gzip, which sidesteps the SDK mismatch on every target and keeps
# gzip-compressed font support.
meson setup build \
    --buildtype=release \
    --cross-file ${PROJECT_DIR}/cross-files/${OS}-${ARCH}.ini \
    --prefix="${OUTPUT_DIR}" \
    -Dbrotli=disabled \
    -Dbzip2=disabled \
    -Dharfbuzz=enabled \
    -Dmmap=disabled \
    -Dpng=disabled \
    -Dtests=disabled \
    -Dzlib=internal
meson compile -C build
meson install -C build
