# Lua NodeMCU Project Boilerplate

This is a reference project for NodeMCU Lua development. 
It aims to help starting developers with NodeMCU development and Lua code style.
This repository contains a few helper scripts and tools which I like to use during development for my ESP-32 modules.
The tools are not yet fully defined and I'm still working on a better local development environment for NodeMCU.
So all PR's are welcome.

# Repository content
- Easy custom NodeMCU firmware building setup
- Lua Code Quality tools
- Lua NodeMCU unit tests
- NodeMCU LFS setup
- NodeMCU OTA setup

## Requirements
- [Lua Rocks](https://luarocks.org/) for MacOS run `brew install luarocks`
- For static code analysis [LuaCheck](https://github.com/mpeterv/luacheck) 
- Python and PIP
- Docker
- NPM
- For NodeMCU development I prefer to use the following software:
    - [NodeMCU](https://github.com/AndiDittrich/NodeMCU-Tool)
    - [ESPTool](https://github.com/espressif/esptool)
    - [NodeMCU Uploader](https://github.com/kmpm/nodemcu-uploader)

## Developing on NodeMCU

This part will explain the following NodeMCU development steps:
Building the firmware, flashing the firmware and uploading / executing Lua code on the NodeMCU module.  

Make sure you have a local copy of the [NodeMCU firmware](https://github.com/nodemcu/nodemcu-firmware) installed at `./docker-bin/nodemcu/nodemcu-firmware`
GIT submodules should've already cloned this repository.

To make any custom edits to the NodeMCU firmware settings edit `./docker-bin/nodemcu/app/include/user_config.h` and `./docker-bin/nodemcu/app/include/user_modules.h`

### Building and flashing the firmware

Building a new version of the NodeMCU firmware can be done by following these few steps:
- Navigate to the `docker-bin` directory 
- Run `docker-compose run nodemcu build`
  - This starts the NodeMCU docker image and builds the firmware
  - The new firmware will be placed in the `./docker-bin/nodemcu/nodemcu-firmware/bin` folder

Flashing the firmware is also quite easy:
- Make sure the NodeMCU module is connected
- Use the NodeMCU-Tool to determine which serial is your NodeMCU module run: `nodemcu-tool devices`
- Once you've located your device, execute the following command to flash the new version `esptool.py --port <serial-port> write_flash -fm dio 0x00000 ./docker-bin/nodemcu/nodemcu-firmware/bin/nodemcu_float_master_<version>.bin`
  - See the esptool Github repository for more information

### Uploading and executing custom Lua code

To upload custom code we use [NodeMCU Uploader](https://github.com/kmpm/nodemcu-uploader)
Uploading code can be done by using the following command:

`nodemcu-uploader --port <serial-port> upload *.lua` this uploads all files ending with .lua in the current directory

Executing code is done in a similar manner:

`nodemcu-uploader --port <serial-port> file do <filename>.lua`

## NodeMCU Lua Development

To start Lua development follow these steps:
- Run `yarn install`
- To use Gulp for code formatting and additional features run `yarn global add gulp`
  This installs gulp on your machine and allows you to use the `gulp` command

### Code Quality

The following commands have been defined in the `Gulpfile.js and package.json` to assist with LUA code style

| Command              | Description  |
| -------------------- | ------------ |
| `gulp validate`      | Validates the code against the defined Lua prettier config [Lua](https://github.com/prettier/plugin-lua)|
| `gulp format`        | Formats the code according to the defined Lua prettier config |
| `gulp luacheck`      | Runs LuaCheck based on the local .luacheckrc file             |

## Roadmap

- Switch to 1 global tool for commands such as format, validate and etc
- Better unit test integration
- Unit tests to run directly on the NodeMCU modules
- Fully working OTA setup
- Easier to use tooling for flashing and building the firmware

## Special Thanks

- [Nikolay Fiykov](https://github.com/fikin/nodemcu-lua-mocks) (NodeMCU Lua API Mocks)
- [Vladimir Dronnikov](https://github.com/dvv) (Lua HTTP Server module)

## Contributing

See CONTRIBUTE.md
