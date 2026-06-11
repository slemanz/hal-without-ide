cmake_minimum_required(VERSION 3.15)

project(hal-no-ide LANGUAGES C)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_compile_definitions(USE_HAL_DRIVER)
add_compile_options(-std=gnu11 -Wall -O0 -g3 -ffunction-sections -fdata-sections)

set(APP_SOURCES
    app/Src/main.c
    app/Src/config.c
    drivers/Device/startup.c
    drivers/Device/syscalls.c
    drivers/Device/system_stm32f4xx.c)

add_executable(firmware ${APP_SOURCES})

set_target_properties(firmware PROPERTIES OUTPUT_NAME "flash.elf")

target_include_directories(firmware PRIVATE
    app/Inc)

target_link_options(firmware PRIVATE
    -T ${CMAKE_SOURCE_DIR}/drivers/Device/STM32F411.ld
    --specs=nano.specs
    --specs=nosys.specs
    -Wl,--gc-sections)

include(cmake/stm32f4xx-hal.cmake)
target_link_libraries(firmware stm32f4xx-hal)

add_custom_command(TARGET firmware POST_BUILD
    COMMAND arm-none-eabi-objcopy -O binary $<TARGET_FILE:firmware> ${CMAKE_BINARY_DIR}/flash.bin
    COMMAND arm-none-eabi-size $<TARGET_FILE:firmware>)

add_custom_target(flash
    COMMAND jlink -CommanderScript flash.jlink
    DEPENDS firmware
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    VERBATIM)
