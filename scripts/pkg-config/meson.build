# https://mesonbuild.com/External-Project-module.html

project('pkg-config', 'c')

mod = import('unstable-external_project')

# pkg-config 0.29.2 vendors a 2012-era glib (`--with-internal-glib`), and
# clang 16 promoted -Wint-conversion and -Wimplicit-function-declaration from
# warnings to errors, which that glib trips four times in gatomic.c. Rebuild
# CFLAGS here rather than letting the external_project module supply them, so
# the cross-file's own c_args survive alongside the two downgrades.
c_args = get_option('c_args')
legacy_c_args = c_args + [
    '-Wno-int-conversion',
    '-Wno-implicit-function-declaration',
]

p = mod.add_project('configure',
    configure_options : [
        '--prefix=@PREFIX@',
        'CFLAGS=@0@'.format(' '.join(legacy_c_args)),
        '--disable-static',
        '--enable-fast-instal=true',
        '--disable-dependency-tracking',
        '--with-pic',
        '--with-aix-soname=aix',
        '--without-gnu-ld',
        '--with-internal-glib',
        '--without-gcov',
    ],
    verbose: true,
)

pkg_config_dep = p.dependency('pkg-config')
meson.override_dependency('pkg-config', pkg_config_dep)
