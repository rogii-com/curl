if(
    NOT DEFINED ROOT
    OR NOT DEFINED ARCH
)
    message(
        FATAL_ERROR
        "Assert: ROOT = ${ROOT}; ARCH = ${ARCH}"
    )
endif()

set(
    BUILD
    0
)

if(DEFINED ENV{BUILD_NUMBER})
    set(
        BUILD
        $ENV{BUILD_NUMBER}
    )
endif()

set(
    TAG
    ""
)

if(DEFINED ENV{TAG})
    set(
        TAG
        "$ENV{TAG}"
    )
else()
    find_package(
        Git
    )

    if(Git_FOUND)
        execute_process(
            COMMAND
                ${GIT_EXECUTABLE} rev-parse --short HEAD
            OUTPUT_VARIABLE
                TAG
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        set(
            TAG
            "_${TAG}"
        )
    endif()
endif()

set(
    PROJECT_ROOT_PATH
    "${CMAKE_CURRENT_LIST_DIR}/.."
)

set(
    ROGII_FOLDER_PATH
    "${CMAKE_CURRENT_LIST_DIR}"
)

include(
    "${ROGII_FOLDER_PATH}/version.cmake"
)

set(
    PACKAGE_NAME
    "curl-${ROGII_PKG_VERSION}-${ARCH}-${BUILD}${TAG}"
)

set(
    CMAKE_INSTALL_PREFIX
    ${ROOT}/${PACKAGE_NAME}
)

set(COMMON_BUILD_OPT
    # -DBUILD_SHARED_LIBS=OFF
    # -DBUILD_STATIC_LIBS=ON
    -DBUILD_CURL_EXE=OFF
    -DBUILD_TESTING=OFF
    -DCURL_USE_LIBPSL=OFF
    -DBUILD_EXAMPLES=OFF
    -DBUILD_LIBCURL_DOCS=OFF
    -DBUILD_MISC_DOCS=OFF
    -DENABLE_CURL_MANUAL=OFF
    -DCMAKE_DEBUG_POSTFIX=d
)

set(
    DEBUG_PATH
    "${CMAKE_CURRENT_LIST_DIR}/../build/debug_${ARCH}"
)

file(
    MAKE_DIRECTORY
    "${DEBUG_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -G Ninja -DCMAKE_BUILD_TYPE=Debug ${COMMON_BUILD_OPT} -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ../..
    WORKING_DIRECTORY
        "${DEBUG_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build . --target install
    WORKING_DIRECTORY
        "${DEBUG_PATH}"
)

set(
    RELEASE_PATH
    "${CMAKE_CURRENT_LIST_DIR}/../build/release_${ARCH}"
)

file(
    MAKE_DIRECTORY
    "${RELEASE_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo ${COMMON_BUILD_OPT} -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ../..
    WORKING_DIRECTORY
        "${RELEASE_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build . --target install
    WORKING_DIRECTORY
        "${RELEASE_PATH}"
)

if(UNIX)
    file(GLOB files "${CMAKE_INSTALL_PREFIX}/lib/*.so*")
    foreach(file ${files})
        execute_process(
            COMMAND
                bash ${ROGII_FOLDER_PATH}/utils/split_debug_info.sh "${file}"
            WORKING_DIRECTORY
                "${CMAKE_INSTALL_PREFIX}/lib"
        )
    endforeach()
endif()

file(
    COPY
        "${ROGII_FOLDER_PATH}/package.cmake"
    DESTINATION
        "${CMAKE_INSTALL_PREFIX}"
)

file(
    REMOVE_RECURSE
    "${DEBUG_PATH}"
    "${RELEASE_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
        "${ROOT}"
)
