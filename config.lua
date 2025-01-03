Config = {}

-- Basic Settings
Config.Debug = false -- Enable/disable debug messages
Config.Locale = 'en' -- Language (de/en/lt)

-- Ped Settings
Config.PedTimeout = 15 -- Time in minutes before a sleeping ped is removed
Config.PedCheckInterval = 1 -- Interval in minutes to check for old peds
Config.PedOffset = -1.0 -- Z-offset for the ped's position (height above the ground)

-- Text Settings
Config.TextSettings = {
    Font = 4, -- Font ID for the 3D text
    Scale = 0.55, -- Base scaling for the 3D text
    Color = {r = 255, g = 255, b = 255, a = 255}, -- Text color (RGB + Alpha)
    DrawDistance = 15.0, -- Maximum distance for the text to be visible
}

-- Animation Settings
Config.Animation = {
    Dict = "timetable@tracy@sleep@", -- Animation dictionary
    Name = "idle_c", -- Animation name
    Flag = 1, -- Animation flag
    BlendIn = 8.0, -- Transition speed into the animation
    BlendOut = -8.0, -- Transition speed out of the animation
}

-- Localization
Config.Locales = {
    ['de'] = {
        ['sleeping'] = 'Spieler Schläft',
        ['name'] = 'Name: %s',
        ['unknown'] = 'Unbekannt',
        ['license'] = "Lizenz: %s"
    },
    ['en'] = {
        ['sleeping'] = 'Player Sleeping',
        ['name'] = 'Name: %s',
        ['unknown'] = 'Unknown',
        ['license'] = "License: %s"
    },
    ['lt'] = {
        ['sleeping'] = 'Žaidėjas miega',
        ['name'] = 'Vardas: %s',
        ['unknown'] = 'Nežinomas',
        ['license'] = "%s"
    }
}

-- Name Display Settings
Config.NameDisplay = {
    Mode = "license", -- Modes: false, "name", "license"
    MaskLastname = true, -- Mask last names (e.g., "Doe" becomes "Do*******")
    MaskLength = 2, -- Number of visible characters for masked last names
    Format = nil -- Placeholder; will be dynamically set below
}

-- Dynamically set the Format after Mode is declared
if Config.NameDisplay.Mode == "name" then
    Config.NameDisplay.Format = "~y~"..Config.Locales[Config.Locale].sleeping.."\n~w~"..Config.Locales[Config.Locale].name
elseif Config.NameDisplay.Mode == "license" then
    Config.NameDisplay.Format = "~y~"..Config.Locales[Config.Locale].sleeping.."\n~w~"..Config.Locales[Config.Locale].license
else
    Config.NameDisplay.Format = "~y~"..Config.Locales[Config.Locale].sleeping
end

-- MySQL Settings
Config.MySQL = {
    Tables = {
        Users = "users", -- Name of the Users table
        Fields = {
            Identifier = "identifier", -- Column name for player ID
            Skin = "skin", -- Column name for skin data
            Firstname = "firstname", -- Column name for first name
            Lastname = "lastname" -- Column name for last name
        }
    }
}

-- Permissions
Config.Permissions = {
    FakeCommand = "admin", -- Permission level required for the fake command
    FakeCommandName = "fakesleep" -- Name of the fake sleep command
}
