vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO embree/embree
  REF 489b746c0d5010e0da10345e9dc96768bec9a037
  SHA512 502d6ed12678df20e773da057c234e7f44b5dd0e6b8c488a9a7d2117f7c1ee8fa84aba1b8d3668caf8ebbd51337812bbb2678e71fbb76b7d311ffb723bc4f5da
  HEAD_REF master
)

# TODO ISA options here
# TODO openimageIO and libpng?

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DEMBREE_TUTORIALS=false
)
vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/embree-3.13.4)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)