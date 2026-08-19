# https://mesonbuild.com/External-Project-module.html

project('uchardet', 'c', 'cpp')

cmake = import('cmake')

cpu = host_machine.cpu()
if cpu == 'amd64'
    arch = 'x86_64'
elif cpu == 'arm64'
    arch = 'arm64'
endif

options = cmake.subproject_options()
options.add_cmake_defines({
    'CMAKE_OSX_ARCHITECTURES': arch,
    'CMAKE_OSX_SYSROOT': meson.get_cross_property('cmake_osx_sysroot'),
    'BUILD_STATIC': false,
    # uchardet 0.0.8 asks for cmake_minimum_required(VERSION 2.6), and CMake 4
    # removed compatibility with anything below 3.5. This is the escape hatch
    # CMake itself names in the error.
    'CMAKE_POLICY_VERSION_MINIMUM': '3.5',
})

uchardet = cmake.subproject('uchardet',
    options: options,
)

uchardet_dep = uchardet.dependency('libuchardet')
meson.override_dependency('uchardet', uchardet_dep)
