# ST HAL with CMake

Same firmware as [`makefile/`](../makefile/) (LED blink + UART hello on a Black Pill STM32F411CE), but built with CMake. See the [repo README](../README.md) for the big picture.

## Build and flash

A thin Makefile wraps the CMake calls, so the daily commands are the same as in the `makefile/` project:

```shell
make            # configures (first time only) and builds build/flash.elf + build/flash.bin
make flash      # flashes via J-Link (uses flash.jlink)
make clean      # removes the build folder
```

Under the hood those run the plain CMake commands, which work just as well on their own:

```shell
cmake -G Ninja -B build -DCMAKE_TOOLCHAIN_FILE=cmake/stm32f411.cmake
cmake --build build
cmake --build build --target flash
```

The configure step only needs to run once. After that, `cmake --build build` rebuilds whatever changed.

## How the CMake build works

CMake never compiles anything itself. It works in two phases:

1. **Configure** (`cmake -B build ...`): reads `CMakeLists.txt`, finds the compiler, and generates build files for a real build tool (Ninja here) inside `build/`
2. **Build** (`cmake --build build`): just runs Ninja, which calls `arm-none-eabi-gcc` with the flags that were decided during configure

Everything generated lands in `build/`. The source tree is never touched, so deleting `build/` is a complete clean and nothing of value is lost. If you edit a CMake file, the next build re-runs the configure step on its own.

The toolchain file has to be passed at configure time (`-DCMAKE_TOOLCHAIN_FILE=...`) because CMake tests the compiler before reading the project. Without it, CMake would pick the host compiler and try to build for Windows/Linux instead of the MCU.

Everything in CMake revolves around **targets** (an executable, a library, or a custom command) and properties attached to them. This project has three: the `firmware` executable, the `stm32f4xx-hal` static library and the `flash` custom target. The commands you will see in the files:

| Command | Meaning |
|---------|---------|
| `add_executable` / `add_library` | create a target from a list of sources |
| `target_include_directories` | `-I` flags for that target |
| `target_compile_options` / `target_link_options` | compiler / linker flags for that target |
| `target_link_libraries` | link one target against another |
| `add_compile_definitions` / `add_compile_options` | `-D` defines and flags for every target |
| `add_custom_command` / `add_custom_target` | run arbitrary shell commands (objcopy, size, jlink) |

On `target_*` commands, `PRIVATE` means "only this target uses it" and `PUBLIC` means "this target and everyone who links against it". That is how the HAL library hands its include paths to the firmware automatically.

## The three CMake files

**`cmake/stm32f411.cmake`** is the toolchain file. It tells CMake this is a cross build (`CMAKE_SYSTEM_NAME Generic`), points to `arm-none-eabi-gcc` and sets the CPU flags (Cortex-M4, hard float). It is passed on the command line so the same project could target another MCU with a different toolchain file.

**`cmake/stm32f4xx-hal.cmake`** builds the HAL as a static library. `HAL_SOURCES` lists only the modules the app uses (hal, cortex, rcc, gpio, uart). Its include directories are `PUBLIC`, so anything that links against the library sees the HAL headers, the CMSIS headers and `stm32f4xx_hal_conf.h` automatically.

**`CMakeLists.txt`** defines the `firmware` executable from the app and device sources, links it against the HAL library with the device linker script and newlib-nano, and adds two extras: a post build step that runs `objcopy` (bin file) and `size`, and a `flash` target that calls J-Link.

## Adding a HAL module

Say you want SPI:

1. Uncomment `#define HAL_SPI_MODULE_ENABLED` in `app/Inc/stm32f4xx_hal_conf.h`
2. Add `"${HAL_DIR}/Src/stm32f4xx_hal_spi.c"` to `HAL_SOURCES` in `cmake/stm32f4xx-hal.cmake`

Rebuild and it is in.

## Editor support

CMake exports `build/compile_commands.json` (enabled in `CMakeLists.txt`), and `.vscode/c_cpp_properties.json` points to it, so VS Code IntelliSense matches the real build flags with zero extra setup.
