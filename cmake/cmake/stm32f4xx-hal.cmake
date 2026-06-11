# Builds the ST HAL as a static library with only the modules the app uses.
# To add a module: enable it in app/Inc/stm32f4xx_hal_conf.h and add the
# matching source file to HAL_SOURCES below.

set(HAL_DIR "${CMAKE_SOURCE_DIR}/drivers/stm32f4xx-hal-driver")

set(HAL_SOURCES
    "${HAL_DIR}/Src/stm32f4xx_hal.c"
    "${HAL_DIR}/Src/stm32f4xx_hal_cortex.c"
    "${HAL_DIR}/Src/stm32f4xx_hal_rcc.c"
    "${HAL_DIR}/Src/stm32f4xx_hal_gpio.c"
    "${HAL_DIR}/Src/stm32f4xx_hal_uart.c")

add_library(stm32f4xx-hal STATIC ${HAL_SOURCES})

target_include_directories(stm32f4xx-hal PUBLIC
    ${HAL_DIR}/Inc
    ${CMAKE_SOURCE_DIR}/drivers/Device/cmsis
    ${CMAKE_SOURCE_DIR}/app/Inc) # stm32f4xx_hal_conf.h lives here
