include(${CMAKE_CURRENT_LIST_DIR}/msvs_package.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/windowssdk_package.cmake)

CNPM_ADD_PACKAGE(
    NAME
        ZLib
    VERSION
        1.2.8
    BUILD_NUMBER
        8
    TAG
        "sdk22621_vsbt22"
)