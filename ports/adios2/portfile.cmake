vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ornladios/ADIOS2
    REF v2.8.3
    SHA512 6d8e0c201a89e52d2ce3e5112b3f4cf8c762cad29d485641694e6f48b07841331c70c51c4596a10ebd5fcfff0a23466071f4091c23bc281a501666385b9b6c92
)

set(adios_tools adios2_reorganize bpls)
if (NOT VCPKG_TARGET_IS_WINDOWS)
  list(APPEND adios_tools adios2_deactivate_bp)
endif ()

if ("mpi" IN_LIST FEATURES)
  set(USE_MPI ON)
  list(APPEND adios_tools adios2_iotest adios2_reorganize_mpi)
else ()
  set(USE_MPI OFF)
endif ()
if ("python" IN_LIST FEATURES)
  set(USE_PYTHON ON)
else ()
  set(USE_PYTHON OFF)
endif ()
if ("zfp" IN_LIST FEATURES)
  set(USE_ZFP ON)
else ()
  set(USE_ZFP OFF)
endif ()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DADIOS2_USE_BP5=OFF
        -DADIOS2_USE_BZip2=OFF
        -DADIOS2_USE_Blosc=OFF
        -DADIOS2_USE_CUDA=OFF
        -DADIOS2_USE_DAOS=OFF
        -DADIOS2_USE_DataMan=OFF
        -DADIOS2_USE_DataSpaces=OFF
        -DADIOS2_USE_Endian_Reverse=OFF
        -DADIOS2_USE_Fortran=OFF
        -DADIOS2_USE_HDF5=OFF
        -DADIOS2_USE_IME=OFF
        -DADIOS2_USE_LIBPRESSIO=OFF
        -DADIOS2_USE_MGARD=OFF
        -DADIOS2_USE_MHS=OFF
        -DADIOS2_USE_MPI=${USE_MPI}
        -DADIOS2_USE_PNG=OFF
        -DADIOS2_USE_Profiling=OFF
        -DADIOS2_USE_Python=${USE_PYTHON}
        -DADIOS2_USE_SST=OFF
        -DADIOS2_USE_SZ=OFF
        -DADIOS2_USE_Sodium=OFF
        -DADIOS2_USE_SysVShMem=OFF
        -DADIOS2_USE_ZFP=${USE_ZFP}
        -DADIOS2_USE_ZeroMQ=OFF
        -DADIOS2_BUILD_EXAMPLES=OFF
        -DADIOS2_INSTALL_GENERATE_CONFIG=OFF
        -DBUILD_TESTING=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_copy_tools(TOOL_NAMES ${adios_tools} AUTO_CLEAN)

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/adios2)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/adios2/toolkit/sst/dp" "${CURRENT_PACKAGES_DIR}/include/adios2/toolkit/sst/util")

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
