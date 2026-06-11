# ST HAL with a plain Makefile

LED blink + UART hello on a Black Pill (STM32F411CE), built with a single short Makefile. See the [repo README](../README.md) for the big picture.

## Build and flash

```shell
make            # builds build/flash.elf and build/flash.bin
make flash      # flashes via J-Link (uses flash.jlink)
make clean      # removes the build folder
```

## Folder layout

```
app/
├── Inc/
│   ├── config.h               # pin definitions and init API
│   └── stm32f4xx_hal_conf.h   # selects which HAL modules exist in the build
└── Src/
    ├── config.c               # GPIO + UART init, SysTick handler, printf retarget
    └── main.c                 # the application
drivers/
├── Device/                    # startup.c, syscalls.c, linker script, system_stm32f4xx.c, CMSIS headers
└── stm32f4xx-hal-driver/      # official ST HAL, untouched
```

## How the Makefile works

There are two object lists:

- `OBJS`: the application and device files (main, config, startup, syscalls, system)
- `DRIVERS`: the HAL modules the app actually uses, nothing more

```make
DRIVERS += $(DIR_BUILD)/stm32f4xx_hal.o
DRIVERS += $(DIR_BUILD)/stm32f4xx_hal_cortex.o
DRIVERS += $(DIR_BUILD)/stm32f4xx_hal_rcc.o
DRIVERS += $(DIR_BUILD)/stm32f4xx_hal_gpio.o
DRIVERS += $(DIR_BUILD)/stm32f4xx_hal_uart.o
```

Three pattern rules teach make where to find sources: `app/Src/`, `drivers/Device/` and `drivers/stm32f4xx-hal-driver/Src/`. When a `.o` shows up in a list, make picks the rule that matches an existing `.c` file. Adding a file to the build means adding one line to a list.

The link uses the device linker script plus newlib-nano (`--specs=nano.specs --specs=nosys.specs`), and `-Wl,--gc-sections` drops every function the app never calls, so unused HAL code does not bloat the binary.

## Adding a HAL module

Say you want SPI:

1. Uncomment `#define HAL_SPI_MODULE_ENABLED` in `app/Inc/stm32f4xx_hal_conf.h`
2. Add `DRIVERS += $(DIR_BUILD)/stm32f4xx_hal_spi.o` to the Makefile

Done. The pattern rule for the HAL folder picks it up.

## printf over UART

`drivers/Device/syscalls.c` implements `_write()`, which forwards every character to the weak `__io_putchar()`. `config.c` implements `__io_putchar()` with `HAL_UART_Transmit()`, so plain `printf()` comes out on PA2 at 115200.
