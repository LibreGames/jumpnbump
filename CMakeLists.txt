cmake_minimum_required(VERSION 3.10)

project(jumpnbump)

INCLUDE(FindPkgConfig)

PKG_SEARCH_MODULE(SDL2 REQUIRED sdl2)
message(STATUS "yo")
message(STATUS ${SDL2_INCLUDE_DIRS})
message(STATUS ${SDL2_LIBRARIES})

add_library(sdl.a STATIC
	src/sdl/gfx.c
	src/sdl/interrpt.c
	src/sdl/sound.c
	src/sdl/input.c)

add_executable(jumpnbump src/main.c)

target_include_directories(jumpnbump PUBLIC "src" ${SDL2_INCLUDE_DIRS})
target_include_directories(sdl.a PUBLIC "src" ${SDL2_INCLUDE_DIRS})

target_link_libraries(jumpnbump sdl.a ${SDL2_LIBRARIES})

set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -Wall -O2 -ffast-math -funroll-loops -fno-common")
