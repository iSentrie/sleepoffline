# ESX Ali Sleep Offline

A professional ESX script that creates sleeping peds for offline players. When a player leaves the server, a sleeping ped is created at their position, replicating the exact appearance and clothing of the player.

## Features

- Automatic creation of sleeping peds when players go offline
- Full synchronization of player outfits (including clothing, accessories, masks)
- Automatic removal of peds after a configurable time
- Configurable 3D text display above sleeping players
- Masking of last names for increased privacy
- Multilingual support (German/English)
- Extensive configuration options
- Optimized performance through intelligent resource management
- Debug mode for easy troubleshooting
- Admin test command for manual testing

## Dependencies

- es_extended
- oxmysql

## Preview
[https://streamable.com/yym8pw](https://streamable.com/yym8pw)

## Installation

1. Place the resource in your server's resources folder.
2. Add the following line to your `server.cfg`:
```cfg
ensure ali_sleepoffline
```
3. Adjust the configuration in `config.lua` to suit your needs.
4. Restart your server.

## Configuration

The `config.lua` file offers extensive customization options:

### Basic Settings
```lua
Config.Debug = false -- Enable/disable debug messages
Config.Locale = 'de' -- Language (de/en)
```

### Ped Settings
```lua
Config.PedTimeout = 15 -- Time in minutes before removal
Config.PedCheckInterval = 1 -- Check interval in minutes
Config.PedOffset = -1.0 -- Z-offset for position
```

### Text Settings
```lua
Config.TextSettings = {
    Font = 4,
    Scale = 0.35,
    Color = {r = 255, g = 255, b = 255, a = 255},
    DrawDistance = 15.0
}
```

### Name Display
```lua
Config.NameDisplay = {
    Enabled = true,
    MaskLastname = true,
    MaskLength = 3,
    Format = "~y~Player Sleeping\n~w~Name: %s"
}
```

## Admin Commands

- `/fakesleep` - Creates a fake ped at your position (Admin rights required)

## Support

If you have any questions or issues, feel free to contact me:
- Discord: AliOG1337

## License

This script is copyright-protected. Any redistribution or modification without explicit permission is prohibited.

© 2024 AliOG. All rights reserved.  
"# ali_sleepoffline"
