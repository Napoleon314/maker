SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/../../${CFG_BINARY_PATH}/${BUILD_CONFIG_PATH})
SET(CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/../../${CFG_BINARY_PATH}/${BUILD_CONFIG_PATH})
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/../../${CFG_BINARY_PATH}/${BUILD_CONFIG_PATH})
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/../../${CFG_BINARY_PATH}/${BUILD_CONFIG_PATH})
FOREACH( OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES} )
    STRING( TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG_UPPER )
    SET( CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG_UPPER} ${PROJECT_BINARY_DIR}/../../${CFG_BINARY_PATH}/${BUILD_CONFIG_PATH}/${OUTPUTCONFIG} )
    SET( CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY_${OUTPUTCONFIG_UPPER} ${PROJECT_BINARY_DIR}/../../${CFG_BINARY_PATH}/${BUILD_CONFIG_PATH}/${OUTPUTCONFIG} )
    SET( CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG_UPPER} ${PROJECT_BINARY_DIR}/../../${CFG_BINARY_PATH}/${BUILD_CONFIG_PATH}/${OUTPUTCONFIG} )
    SET( CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG_UPPER} ${PROJECT_BINARY_DIR}/../../${CFG_BINARY_PATH}/${BUILD_CONFIG_PATH}/${OUTPUTCONFIG} )
ENDFOREACH( OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES )
