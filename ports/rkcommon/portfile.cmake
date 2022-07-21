vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ospray/rkcommon
    REF 0b8856cd9278474b56dc5bcff516a4b9482cf147
    SHA512 836e888e33406f6825b8f5570894402460b3ae65a68ca8aeecf2c8e712f70e9392fdbb2131d538dbf47fc48a0664568e1fd60968452c7517cfeb17c0e608fecf
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
      -DBUILD_TESTING=false
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/rkcommon-1.10.0)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

