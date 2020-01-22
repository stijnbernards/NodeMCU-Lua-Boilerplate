# Lua NodeMCU Project Boilerplate

This is a reference project for NodeMCU Lua development. 
It aims to help starting developers with NodeMCU development and Lua code style.
This repository contains a few helper scripts and tools which I like to use during development for my ESP-32 modules.
The tools are not yet fully defined and I'm still working on a better local development environment for NodeMCU.
So all PR's are welcome.

# Repository content
- NodeMCU firmware building and flash setup
- Lua Code Quality tools
- Lua NodeMCU unit tests
- NodeMCU LFS setup
- NodeMCU OTA setup

## Requirements
- Lua
- [Lua Rocks](https://luarocks.org/) for MacOS run `brew install luarocks`
- For static code analysis [LuaCheck](https://github.com/mpeterv/luacheck) 
- Python and PIP
- Docker
- NPM and Yarn
- For NodeMCU development I prefer to use the following software:
    - [NodeMCU](https://github.com/AndiDittrich/NodeMCU-Tool)
    - [ESPTool](https://github.com/espressif/esptool)
    - [NodeMCU Uploader](https://github.com/kmpm/nodemcu-uploader)

## Developing on NodeMCU

This part will explain the following NodeMCU development steps:
Building the firmware, flashing the firmware and uploading / executing Lua code on the NodeMCU module.  

To make any custom edits to the NodeMCU firmware settings edit `./docker-bin/nodemcu/app/include/user_config.h` and `./docker-bin/nodemcu/app/include/user_modules.h`

### Building and flashing the firmware

Building a new version of the NodeMCU firmware can be done by following these few steps:
- Run `docker-compose run nodemcu build`
  - This starts the NodeMCU docker image and builds the firmware
  - The new firmware will be placed in the `./docker-bin/nodemcu/nodemcu-firmware/bin` folder

Flashing the firmware is also quite easy:
- Make sure the NodeMCU module is connected
- Use the NodeMCU-Tool to determine which serial is your NodeMCU module run: `yarn devices`
- Once you've located your device, execute the following command to flash the new version `esptool.py --port <serial-port> write_flash -fm dio 0x00000 ./docker-bin/nodemcu/nodemcu-firmware/bin/nodemcu_float_master_<version>.bin` or `yarn flash <serial-port> <firmware>`
  - See the [ESPTool Github repository](https://github.com/espressif/esptool) for more information.

### Uploading and executing custom Lua code

To upload custom code we use [NodeMCU Uploader](https://github.com/kmpm/nodemcu-uploader)
Uploading code can be done by using the following command:

`nodemcu-uploader --port <serial-port> upload *.lua` or `yarn upload <serial-port>` this uploads all files ending with .lua in the current directory

Executing code is done in a similar manner:

`nodemcu-uploader --port <serial-port> file do <filename>.lua`

## NodeMCU Lua Development

To start Lua development make sure to first run `yarn install` in the root directory.
The following commands have been defined in the `package.json` file to assist with LUA code style

| Command                               | Description                                                                                              |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `yarn format`                         | Formats the code according to the defined Lua prettier config                                            |
| `yarn lint:prettier`                  | Validates the code against the defined Lua prettier config [Lua](https://github.com/prettier/plugin-lua) |
| `yarn lint:luacheck`                  | Runs LuaCheck based on the local .luacheckrc file                                                        |
| `yarn lint`                           | Runs all configured linting tools                                                                        |
| `yarn test`                           | Runs all tests defined in `./tests`                                                                      |
| `yarn devices`                        | Gets all connected devices using nodemcu-tool                                                            |
| `yarn upload <serial-port>`           | Uploads all files using nodemcu-uploader ending with .lua to the specified device                        |
| `yarn terminal <serial-port>`         | Connects to the specified device using nodemcu-uploader                                                  |
| `yarn exec <serial-port>`             | Executes init.lua using Lua file do on the specified device                                              |
| `yarn build-firmware`                 | Builds the NodeMCU firmware via Docker Compose                                                           |
| `yarn flash <serial-port> <firmware>` | Flashes the specified device with the specified firmware using esptool.py                                |

## Road Map

- Switch to 1 global tool for commands such as format, validate and etc
- Github CI/CD
- Better unit test integration
- Unit tests to run directly on the NodeMCU modules
- Fully working OTA setup
- Easier to use tooling for flashing and building the firmware

## Special Thanks

- [Nikolay Fiykov](https://github.com/fikin/nodemcu-lua-mocks) (NodeMCU Lua API Mocks)
- [Vladimir Dronnikov](https://github.com/dvv) (Lua HTTP Server module)

## Contributing

See CONTRIBUTE.md
