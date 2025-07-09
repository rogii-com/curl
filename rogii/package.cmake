if(TARGET libcurl)
    return()
endif()

add_library(libcurl SHARED IMPORTED)
add_library(CURL::libcurl_shared ALIAS libcurl)

if(MSVC)
    set_target_properties(
        libcurl
        PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/bin/libcurl.dll"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/bin/libcurld.dll"
            INTERFACE_INCLUDE_DIRECTORIES
                "${CMAKE_CURRENT_LIST_DIR}/include"
            IMPORTED_IMPLIB
                "${CMAKE_CURRENT_LIST_DIR}/lib/libcurl_imp.lib"
            IMPORTED_IMPLIB_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/lib/libcurld_imp.lib"
    )
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set_target_properties(
        libcurl
        PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/lib/libcurl.so"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/lib/libcurld.so"
            INTERFACE_INCLUDE_DIRECTORIES
                "${CMAKE_CURRENT_LIST_DIR}/include"
    )
endif()

set(
    COMPONENT_NAMES

    CNPM_RUNTIME_libcurl
    CNPM_RUNTIME
)

foreach(COMPONENT_NAME ${COMPONENT_NAMES})
    install(
        FILES
            $<TARGET_FILE:libcurl>
        DESTINATION
            .
        COMPONENT
            ${COMPONENT_NAME}
        EXCLUDE_FROM_ALL
    )
endforeach()