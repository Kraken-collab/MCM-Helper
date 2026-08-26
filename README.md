[![Build](https://github.com/Kraken-collab/MCM-Helper/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/Kraken-collab/MCM-Helper/actions/workflows/build.yml)

MCM Helper is a framework for simplifying the creation of Mod Configuration Menus for
[SkyUI](https://www.nexusmods.com/skyrimspecialedition/mods/12604).
It is heavily inspired by
[Mod Configuration Menu for Fallout 4 (F4MCM)](https://www.nexusmods.com/fallout4/mods/21497).

## Requirements
* [CMake](https://cmake.org/)
	* Add this to your `PATH`
* [Vcpkg](https://github.com/microsoft/vcpkg)
	* Add the environment variable `VCPKG_ROOT` with the value as the path to the folder containing vcpkg
* [Visual Studio Community 2022](https://visualstudio.microsoft.com/)
	* Desktop development with C++
* [Git](https://git-scm.com/)
	* The build script downloads `common` and `skse64` from `ianpatt/skse64` into `build`

## Register Visual Studio as a Generator
* Open `x64 Native Tools Command Prompt`
* Run `cmake`
* Close the cmd window

## Building
```
git clone https://github.com/Exit-9B/MCM-Helper
cd MCM-Helper
git submodule update --init --recursive

# Build.cmd downloads and builds the official SKSE dependencies into build/
set VCPKG_ROOT= {location}
Build.cmd
```

The archives are written to `package/MCM.Helper.zip` and `package/MCM.SDK.zip`.
