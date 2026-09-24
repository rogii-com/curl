include(${CMAKE_CURRENT_LIST_DIR}/msvs_package.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/windowssdk_package.cmake)

CNPM_ADD_PACKAGE(
    NAME
        ZLib
    VERSION
        1.2.8
    BUILD_NUMBER
        0
    TAG
        "sdk26100_vsbt18"
)