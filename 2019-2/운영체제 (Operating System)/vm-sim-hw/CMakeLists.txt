cmake_minimum_required(VERSION 3.15)
project(vm_sim_hw)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(vm_sim_hw
        pagetable.cpp
        pagetable.h
        vm.cpp)
