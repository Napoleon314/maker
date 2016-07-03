ADD_DEFINITIONS(-DUNICODE -D_UNICODE)

IF(MSVC)
	SET(BUILD_COMPILER_NAME "vc")
	SET(BUILD_COMPILER_MSVC TRUE)
	IF(MSVC_VERSION GREATER 1800)		
		SET(BUILD_COMPILER_VERSION "140")
		#SET(CMAKE_CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /WX /GR- /EHsc")
	ELSE()
		MESSAGE(FATAL_ERROR "The minimum visual studio version is vc140.")
	ENDIF()

	SET(CMAKE_CXX_FLAGS "/DWIN32 /D_WINDOWS /W4 /WX /EHsc /MP /bigobj")
	SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /DBUILD_SHIP /fp:fast /Ob2 /GL /Qpar")
	SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /fp:fast /Ob2 /Qpar")
	SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /fp:fast /Ob1 /Qpar")

	SET(CMAKE_EXE_LINKER_FLAGS "/WX /pdbcompress")
	SET(CMAKE_SHARED_LINKER_FLAGS "/WX /pdbcompress")
	SET(CMAKE_MODULE_LINKER_FLAGS "/WX /pdbcompress")

	SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "/DEBUG:FASTLINK")
	SET(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "/DEBUG:FASTLINK")
	SET(CMAKE_SHARED_LINKER_FLAGS_DEBUG "/DEBUG:FASTLINK")
	SET(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "/DEBUG:FASTLINK")

	SET(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /INCREMENTAL:NO /LTCG /OPT:REF /OPT:ICF")
	SET(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /INCREMENTAL:NO /LTCG /OPT:REF /OPT:ICF")
	SET(CMAKE_MODULE_LINKER_FLAGS_RELEASE "${CMAKE_MODULE_LINKER_FLAGS_RELEASE} /INCREMENTAL:NO /LTCG")
	SET(CMAKE_STATIC_LINKER_FLAGS_RELEASE "${CMAKE_STATIC_LINKER_FLAGS_RELEASE} /LTCG")
	SET(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "${CMAKE_EXE_LINKER_FLAGS_MINSIZEREL} /INCREMENTAL:NO /OPT:REF /OPT:ICF")
	SET(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL "${CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL} /INCREMENTAL:NO /OPT:REF /OPT:ICF")

	IF(${CFG_INTRINSICS_LEVEL} GREATER 2)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /arch:AVX2")
	ELSEIF(${CFG_INTRINSICS_LEVEL} GREATER 1)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /arch:AVX")
	ELSEIF(${CFG_INTRINSICS_LEVEL} GREATER 0 AND BUILD_ARCH_NAME MATCHES "x86")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /arch:SSE2")
	ENDIF()

	IF(BUILD_ARCH_NAME MATCHES "x86")
		SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /arch:SSE")
		SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /arch:SSE")
		SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /arch:SSE")

		SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /LARGEADDRESSAWARE")
		SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /LARGEADDRESSAWARE")
	ENDIF()

	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Zc:throwingNew")
	#SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /GL")
	SET(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO /LTCG:incremental /OPT:REF /OPT:ICF")
	SET(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO /LTCG:incremental /OPT:REF /OPT:ICF")
	SET(CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO} /LTCG:incremental")
	IF(BUILD_ARCH_NAME MATCHES "arm")
		ADD_DEFINITIONS(-D_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE=1)
	ENDIF()

	IF(BUILD_PLATFORM_WINDOWS_RUNTIME)
		SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /INCREMENTAL:NO")
		SET(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO")
		SET(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} /INCREMENTAL:NO")
		SET(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO")
	ELSE()
		SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /GS-")
		SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /GS-")
		SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /GS-")

		SET(CMAKE_STATIC_LINKER_FLAGS "/WX")
	ENDIF()

	SET(CMAKE_C_FLAGS ${CMAKE_CXX_FLAGS})

ELSE()
	IF(CMAKE_C_COMPILER_ID STREQUAL "Clang")
		SET(BUILD_COMPILER_NAME "clang")
		SET(BUILD_COMPILER_CLANG TRUE)
		IF(BUILD_PLATFORM_WINDOWS)
			ADD_DEFINITIONS(-D_WIN32_WINNT=0x0501)
		ENDIF()
	ELSEIF(MINGW)
		SET(BUILD_COMPILER_NAME "mgw")
		SET(BUILD_COMPILER_GCC TRUE)
		ADD_DEFINITIONS(-D_WIN32_WINNT=0x0501)
	ELSE()
		SET(BUILD_COMPILER_NAME "gcc")
		SET(BUILD_COMPILER_GCC TRUE)
	ENDIF()

	IF(BUILD_COMPILER_CLANG)
		EXECUTE_PROCESS(COMMAND ${CMAKE_C_COMPILER} --version OUTPUT_VARIABLE CLANG_VERSION)
		STRING(REGEX MATCHALL "[0-9]+" CLANG_VERSION_COMPONENTS ${CLANG_VERSION})
		LIST(GET CLANG_VERSION_COMPONENTS 0 CLANG_MAJOR)
		LIST(GET CLANG_VERSION_COMPONENTS 1 CLANG_MINOR)
		SET(BUILD_COMPILER_VERSION ${CLANG_MAJOR}${CLANG_MINOR})
		IF(BUILD_PLATFORM_WINDOWS)
			EXECUTE_PROCESS(COMMAND gcc -dumpversion OUTPUT_VARIABLE GCC_VERSION)
			STRING(STRIP ${GCC_VERSION} GCC_VERSION)

			EXECUTE_PROCESS(COMMAND where clang OUTPUT_VARIABLE CLANG_PATH)
			STRING(REPLACE \\ / CLANG_PATH ${CLANG_PATH})
			STRING(FIND ${CLANG_PATH} / SLASH_POS REVERSE)
			STRING(SUBSTRING ${CLANG_PATH} 0 ${SLASH_POS} CLANG_PATH)
			
			IF(EXISTS "${CLANG_PATH}/../lib/gcc/i686-w64-mingw32/${GCC_VERSION}/include/c++/")
				SET(MINGW_NAME "i686-w64-mingw32")
				SET(MINGW_IN_LIB_FOLDER 1)
			ELSEIF(EXISTS "${CLANG_PATH}/../lib/gcc/x86_64-w64-mingw32/${GCC_VERSION}/include/c++/")
				SET(MINGW_NAME "x86_64-w64-mingw32")
				SET(MINGW_IN_LIB_FOLDER 1)
			ELSEIF(EXISTS "${CLANG_PATH}/../lib/gcc/mingw32/${GCC_VERSION}/include/c++/")
				SET(MINGW_NAME "mingw32")
				SET(MINGW_IN_LIB_FOLDER 1)
			ELSEIF(EXISTS "${CLANG_PATH}/../i686-w64-mingw32/include/c++/")
				SET(MINGW_NAME "i686-w64-mingw32")
				SET(MINGW_IN_LIB_FOLDER 0)
			ELSEIF(EXISTS "${CLANG_PATH}/../x86_64-w64-mingw32/include/c++/")
				SET(MINGW_NAME "x86_64-w64-mingw32")
				SET(MINGW_IN_LIB_FOLDER 0)
			ELSEIF(EXISTS "${CLANG_PATH}/../mingw32/include/c++/")
				SET(MINGW_NAME "mingw32")
				SET(MINGW_IN_LIB_FOLDER 0)
			ENDIF()

			IF(MINGW_IN_LIB_FOLDER)
				SET(MINGW_CXX_INCLUDE "${CLANG_PATH}/../lib/gcc/${MINGW_NAME}/${GCC_VERSION}/include/c++/")
			ELSE()
				SET(MINGW_CXX_INCLUDE "${CLANG_PATH}/../${MINGW_NAME}/include/c++/")
			ENDIF()
			INCLUDE_DIRECTORIES(${MINGW_CXX_INCLUDE})
			INCLUDE_DIRECTORIES(${MINGW_CXX_INCLUDE}${MINGW_NAME}/)
		ENDIF()
	ELSE()
		EXECUTE_PROCESS(COMMAND ${CMAKE_C_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION)
		STRING(REGEX MATCHALL "[0-9]+" GCC_VERSION_COMPONENTS ${GCC_VERSION})
		LIST(GET GCC_VERSION_COMPONENTS 0 GCC_MAJOR)
		LIST(GET GCC_VERSION_COMPONENTS 1 GCC_MINOR)
		SET(BUILD_COMPILER_VERSION ${GCC_MAJOR}${GCC_MINOR})
	ENDIF()

	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -W -Wall -Werror")
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -W -Wall -Werror")
	IF(NOT (ANDROID OR IOS))
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=core2 -msse2")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=core2 -msse2")
		IF(${CFG_INTRINSICS_LEVEL} GREATER 2)
			SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mavx")
		ELSEIF(${CFG_INTRINSICS_LEVEL} GREATER 1)
			SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mavx")
		ELSEIF(${CFG_INTRINSICS_LEVEL} GREATER 0)
			SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -msse2")
		ENDIF()
	ENDIF()
	IF(BUILD_COMPILER_CLANG)
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11 -Wno-inconsistent-missing-override")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wno-inconsistent-missing-override")
		IF(BUILD_COMPILER_VERSION STRGREATER "34")
			SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
		ENDIF()
	ELSE()
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
		IF(BUILD_COMPILER_VERSION STRGREATER "48")
			SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
		ENDIF()
	ENDIF()
	SET(CMAKE_CXX_FLAGS_DEBUG "-DDEBUG -g -O0")
	SET(CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG -O2 -DBUILD_SHIP")
	SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-DNDEBUG -g -O2")
	SET(CMAKE_CXX_FLAGS_MINSIZEREL "-DNDEBUG -Os")
	IF(BUILD_ARCH_NAME STREQUAL "x86")
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
		SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -m32")
		SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -m32")
		SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m32")
		IF(BUILD_PLATFORM_WINDOWS)
			SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--large-address-aware")
			SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--large-address-aware")
			SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--large-address-aware")

			SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=pe-i386")
		ELSE()
			SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=elf32-i386")
		ENDIF()
	ELSEIF((BUILD_ARCH_NAME STREQUAL "x64") OR (BUILD_ARCH_NAME STREQUAL "x86_64"))
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m64")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64")
		SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -m64")
		SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -m64")
		SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m64")
		IF(BUILD_PLATFORM_WINDOWS)
			SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=pe-x86-64")
		ELSE()
			SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=elf64-x86-64")
		ENDIF()
	ENDIF()
	SET(CMAKE_SHARED_LINKER_FLAGS_RELEASE "-s")
	SET(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL "-s")
	SET(CMAKE_MODULE_LINKER_FLAGS_RELEASE "-s")
	SET(CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL "-s")
	SET(CMAKE_EXE_LINKER_FLAGS_RELEASE "-s")
	SET(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "-s")
ENDIF()

SET(CMAKE_C_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG})
SET(CMAKE_C_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE})
SET(CMAKE_C_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
SET(CMAKE_C_FLAGS_MINSIZEREL ${CMAKE_CXX_FLAGS_MINSIZEREL})
IF(RTTI_FORCE_ON)
	SET(RTTI_FLAG "")
	SET(NO_RTTI_FLAG "")
ELSE()
	IF(MSVC)
		SET(RTTI_FLAG "/GR")
		SET(NO_RTTI_FLAG "/GR-")
	ELSE()
		SET(RTTI_FLAG "-frtti")
		SET(NO_RTTI_FLAG "-fno-rtti")
	ENDIF()
ENDIF()
SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${NO_RTTI_FLAG}")
SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${NO_RTTI_FLAG}" )
SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${NO_RTTI_FLAG}")
SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} ${NO_RTTI_FLAG}")
IF(BUILD_PLATFORM_LINUX)
	SET(CMAKE_CXX_FLAGS "-fpic ${CMAKE_CXX_FLAGS}")
	SET(CMAKE_C_FLAGS "-fpic ${CMAKE_C_FLAGS}")
ENDIF()

SET(BUILD_OUTPUT_SUFFIX _${BUILD_COMPILER_NAME}${BUILD_COMPILER_VERSION})
