# Building the ST HAL without an IDE

This repo shows how to compile a firmware that uses the official ST HAL with nothing but a compiler and a build script. No CubeIDE, no CubeMX, no magic. The same application is built in two ways so you can compare them side by side:

| Folder | Build system |
|--------|--------------|
| [`makefile/`](makefile/) | Plain GNU Make, one short Makefile |
| [`cmake/`](cmake/) | CMake with a toolchain file, plus a thin Makefile wrapper |

## The application

Target board is the Black Pill (STM32F411CE). The firmware:

- Blinks the onboard LED (PC13) every 500 ms
- Prints a hello message on USART2 (TX = PA2, 115200 8N1) every 5 seconds

All peripheral setup lives in `app/Src/config.c`. The main loop is non blocking and uses `HAL_GetTick()` for timing.

## The idea

The HAL is just a set of C files. To build it you only need three things:

1. The HAL sources and headers (`drivers/stm32f4xx-hal-driver/`, the official repo from ST)
2. A `stm32f4xx_hal_conf.h` where you enable only the modules you use (`app/Inc/`)
3. The CMSIS device files: startup code, `system_stm32f4xx.c`, linker script and device headers (`drivers/Device/`)

Both projects compile only the HAL modules the application actually needs (hal, cortex, rcc, gpio, uart). Everything else stays out of the build. To use another peripheral, enable its module in `stm32f4xx_hal_conf.h` and add its source file to the build. That is the whole trick.

## Requirements

- Arm GNU Toolchain (`arm-none-eabi-gcc`) on your PATH
- GNU Make for `makefile/`, CMake + Ninja for `cmake/`
- SEGGER J-Link tools for flashing (optional, only needed by `make flash`)

Each folder has its own README with the build commands and an explanation of how the build script works.
