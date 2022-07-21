vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO oneapi-src/oneTBB
    REF 3df08fe234f23e732a122809b40eb129ae22733f
    SHA512 078b0aef93fb49a974adc365a4147cd2d12704e59d448fa2e510cd4ac8fa77cc4c83eebc5612684ed36a907449c876e5717eba581c195e1d9a7faf0ae832cb00
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS -DTBB_TEST=OFF
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/TBB)
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

