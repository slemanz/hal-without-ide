# Toolchain file: tells CMake to cross compile for the STM32F411 (Cortex-M4F)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

set(MCU_FLAGS "-mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16")

set(CMAKE_C_FLAGS_INIT ${MCU_FLAGS})
set(CMAKE_ASM_FLAGS_INIT ${MCU_FLAGS})

add_compile_definitions(STM32F411xE)
