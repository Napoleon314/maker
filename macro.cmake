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

MACRO(SEARCH_LIB_FILES result root_name list)
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
	LIST(REMOVE_DUPLICATES _GROUP_LIST)
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

	

	#MESSAGE(STATUS ${${result}})

ENDMACRO()