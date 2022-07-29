set(ADIOS2_VERSION 2.8.2)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ornladios/ADIOS2
    REF v${ADIOS2_VERSION}
    SHA512 1ae9c1111c1a137ecf041631070511e9b133f376814ae074898d10b28109b0c00c64b61ffb4792e5225253e63af9fae6f81094718e0f08a7d470875405346dd6
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_SHARED_LIBS=OFF
        -DADIOS2_BUILD_EXAMPLES=OFF
        -DBUILD_TESTING=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DADIOS2_USE_BZip2=OFF
        -DADIOS2_USE_Fortran=OFF
        -DADIOS2_USE_HDF5=OFF
        -DADIOS2_USE_PNG=OFF
        -DADIOS2_USE_Profiling=OFF
        -DADIOS2_USE_Python=OFF
        -DADIOS2_USE_SST=OFF
        -DADIOS2_USE_SZ=OFF
        -DADIOS2_USE_SysVShMem=OFF
        -DADIOS2_USE_ZFP=OFF
        -DADIOS2_USE_ZeroMQ=OFF
)

vcpkg_cmake_install()

vcpkg_copy_tools(
  SEARCH_DIR "${CURRENT_PACKAGES_DIR}/bin"
  TOOL_NAMES bpls adios2_iotest adios2_reorganize adios2_reorganize_mpi
)

file(REMOVE "${CURRENT_PACKAGES_DIR}/bin/bpls.exe")
file(REMOVE "${CURRENT_PACKAGES_DIR}/bin/adios2_iotest.exe")
file(REMOVE "${CURRENT_PACKAGES_DIR}/bin/adios2_reorganize.exe")
file(REMOVE "${CURRENT_PACKAGES_DIR}/bin/adios2_reorganize_mpi.exe")

file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/bpls.exe")
file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/adios2_iotest.exe")
file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/adios2_reorganize.exe")
file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/bin/adios2_reorganize_mpi.exe")

vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/adios2)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/adios2/toolkit/sst/dp" "${CURRENT_PACKAGES_DIR}/include/adios2/toolkit/sst/util")

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

