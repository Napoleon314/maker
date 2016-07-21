MACRO(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
        LIST(APPEND dirlist ${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist})
ENDMACRO()

MACRO(SEARCH_FILES result root_name list)
	UNSET(${result})
	UNSET(_GF)
	FOREACH(_P ${${list}})
		SET(_E ${_P}/*)
		FILE(GLOB _F LIST_DIRECTORIES false ${_E})
		LIST(APPEND _GF ${_F})
		LIST(APPEND ${result} ${_F})
		SUBDIRLIST(_L ${_P})
		LIST(APPEND _GROUP_LIST ${_L})
	ENDFOREACH()
	IF(_GROUP_LIST)
		LIST(REMOVE_DUPLICATES _GROUP_LIST)
	ENDIF()
	SOURCE_GROUP(${root_name} FILES ${_GF})
	FOREACH(_G ${_GROUP_LIST})
		UNSET(_GF)
		FOREACH(_P ${${list}})
			SET(_E ${_P}/${_G}/*)
			FILE(GLOB _F LIST_DIRECTORIES false ${_E})
			LIST(APPEND _GF ${_F})
			LIST(APPEND ${result} ${_F})
		ENDFOREACH()
		SOURCE_GROUP(${root_name}\\${_G} FILES ${_GF})
	ENDFOREACH()
	UNSET(_GF)
	FOREACH(_P ${${list}})
		SET(_E ${_P}/Platform/${BUILD_PLATFORM_NAME_LOWER}/*)
		FILE(GLOB _F LIST_DIRECTORIES false ${_E})
		LIST(APPEND _GF ${_F})
		LIST(APPEND ${result} ${_F})
	ENDFOREACH()
	SOURCE_GROUP(${root_name}\\Platform FILES ${_GF})
ENDMACRO()

MACRO(ADD_PRECOMPILED_HEADER target file_list header_name)
	UNSET(_H)
	UNSET(_C)
	UNSET(_CPP)
	FOREACH(_F ${${file_list}})
		IF(_F MATCHES ${header_name}.h)
			SET(_H ${_F})
		ENDIF()
		IF(_F MATCHES ${header_name}.c)
			SET(_C ${_F})
		ENDIF()
		IF(_F MATCHES ${header_name}.cpp)
			SET(_CPP ${_F})
		ENDIF()
	ENDFOREACH()
	IF(_H AND MSVC)
		IF(_CPP)
			SET_TARGET_PROPERTIES(${target} PROPERTIES COMPILE_FLAGS "/Yu${header_name}.h")
			SET_SOURCE_FILES_PROPERTIES(${_CPP} PROPERTIES COMPILE_FLAGS "/Yc${header_name}.h")
		ELSEIF(_C)
			SET_TARGET_PROPERTIES(${target} PROPERTIES COMPILE_FLAGS "/Yu${header_name}.h")
			SET_SOURCE_FILES_PROPERTIES(${_C} PROPERTIES COMPILE_FLAGS "/Yc${header_name}.h")
		ENDIF()
	ENDIF()
ENDMACRO()
