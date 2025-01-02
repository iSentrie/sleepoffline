Config = {}

-- Grundeinstellungen
Config.Debug = false -- Debug-Nachrichten aktivieren/deaktivieren
Config.Locale = 'de' -- (de/en)

-- Ped Einstellungen
Config.PedTimeout = 15 -- Zeit in Minuten, nach der ein schlafender Ped entfernt wird
Config.PedCheckInterval = 1 -- Intervall in Minuten, in dem nach alten Peds gesucht wird
Config.PedOffset = -1.0 -- Z-Offset für die Ped-Position (Höhe über dem Boden)

-- Text Einstellungen
Config.TextSettings = {
    Font = 4, -- Font ID für den 3D Text
    Scale = 0.55, -- Basis-Skalierung des 3D Texts
    Color = {r = 255, g = 255, b = 255, a = 255}, -- Textfarbe (RGB + Alpha)
    DrawDistance = 15.0, -- Maximale Entfernung, ab der der Text angezeigt wird
}

-- Animation Einstellungen
Config.Animation = {
    Dict = "timetable@tracy@sleep@", -- Animations-Dictionary
    Name = "idle_c", -- Animations-Name
    Flag = 1, -- Animations-Flag
    BlendIn = 8.0, -- Übergangsgeschwindigkeit in die Animation
    BlendOut = -8.0, -- Übergangsgeschwindigkeit aus der Animation
}

-- Namensanzeige Einstellungen
Config.NameDisplay = {
    Enabled = true, -- Namensanzeige aktivieren/deaktivieren
    MaskLastname = true, -- Nachnamen maskieren (z.B. "Mustermann" wird zu "Mu*******")
    MaskLength = 2, -- Anzahl der sichtbaren Buchstaben beim maskierten Nachnamen
    Format = "~y~Spieler Schläft\n~w~Name: %s" -- Format der Namensanzeige (%s wird durch den Namen ersetzt)
}

-- MySQL Einstellungen
Config.MySQL = {
    Tables = {
        Users = "users", -- Name der Users-Tabelle
        Fields = {
            Identifier = "identifier", -- Spaltenname für die Spieler-ID
            Skin = "skin", -- Spaltenname für die Skin-Daten
            Firstname = "firstname", -- Spaltenname für den Vornamen
            Lastname = "lastname" -- Spaltenname für den Nachnamen
        }
    }
}

-- Berechtigungen
Config.Permissions = {
    FakeCommand = "admin",
    FakeCommandName = "fakesleep"
}

-- Lokalisierung
Config.Locales = {
    ['de'] = {
        ['sleeping'] = 'Spieler Schläft',
        ['name'] = 'Name: %s',
        ['unknown'] = 'Unbekannt'
    },
    ['en'] = {
        ['sleeping'] = 'Player Sleeping',
        ['name'] = 'Name: %s',
        ['unknown'] = 'Unknown'
    }
}
