cmake_minimum_required(VERSION 2.4)

PROJECT(SEEDS)

#SET(CMAKE_BUILD_TYPE Debug)
SET(CMAKE_BUILD_TYPE Release)
#SET(EXECUTABLE_OUTPUT_PATH ~/bin/EM
#    CACHE PATH "Single output directory for building all executables.")

set(CMAKE_CXX_FLAGS         " -O3")
set(CMAKE_CXX_FLAGS_DEBUG   "-g -pg ")
set(CMAKE_CXX_FLAGS_RELEASE " -pg -O3")

set(CMAKE_C_FLAGS         ${CMAKE_CXX_FLAGS})
set(CMAKE_C_FLAGS_DEBUG   ${CMAKE_CXX_FLAGS_DEBUG})
set(CMAKE_C_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE})


SET(OpenCV_DIR "/usr/include/opencv")
FIND_PACKAGE(OpenCV REQUIRED)
INCLUDE_DIRECTORIES(${OpenCV_DIR})


set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)


ADD_EXECUTABLE(seeds
superpixel_test.cpp
seeds2.cpp)

TARGET_LINK_LIBRARIES(seeds ${OpenCV_LIBS})


