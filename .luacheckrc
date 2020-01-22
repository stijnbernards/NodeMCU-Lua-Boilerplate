allow_defined=true
std = {
    globals = {"app", "config", "setup"}, -- Base NodeMCU application globals
    read_globals = {
        -- C NodeMCU Wifi Module: https://nodemcu.readthedocs.io/en/master/modules/wifi/
        "wifi",
        -- NodeMCU Module: https://nodemcu.readthedocs.io/en/master/modules/node/
        "node",
        -- C MQTT Module: https://nodemcu.readthedocs.io/en/master/modules/mqtt/
        "mqtt",
        -- C Timer Module: https://nodemcu.readthedocs.io/en/master/modules/tmr/
        "tmr",
        -- C DHT Module: https://nodemcu.readthedocs.io/en/master/modules/dht/
        "dht",
        "print",
        "require"
    }
}
