cmake_minimum_required(VERSION 3.20 FATAL_ERROR)
project(devshell)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

add_subdirectory(src)

include(cmake/InstallRules.cmake)