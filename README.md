# ESX Ali Sleep Offline

Ein professionelles ESX-Script, das schlafende Peds für offline Spieler erstellt. Wenn ein Spieler den Server verlässt, wird an seiner Position ein schlafender Ped erstellt, der das exakte Aussehen und die Kleidung des Spielers hat.

## Features

- Automatische Erstellung von schlafenden Peds wenn Spieler offline gehen
- Vollständige Synchronisation der Spieler-Outfits (inkl. Kleidung, Accessoires, Masken)
- Automatische Entfernung der Peds nach konfigurierbarer Zeit
- Konfigurierbare 3D-Text Anzeige über den schlafenden Spielern
- Maskierung der Nachnamen für mehr Privatsphäre
- Mehrsprachig (Deutsch/Englisch)
- Umfangreiche Konfigurationsmöglichkeiten
- Optimierte Performance durch intelligentes Resource-Management
- Debug-Modus für einfache Fehlersuche
- Admin-Testbefehl zum manuellen Testen

## Dependencies

- es_extended
- oxmysql

## Preview
[https://streamable.com/yym8pw](https://streamable.com/yym8pw)

## Installation

1. Lade die Resource in deinen Server-Resources Ordner
2. Füge folgende Zeile in deine server.cfg ein:
```cfg
ensure ali_sleepoffline
```
3. Passe die Konfiguration in der config.lua an deine Bedürfnisse an
4. Starte deinen Server neu

## Konfiguration

Die config.lua bietet umfangreiche Einstellungsmöglichkeiten:

### Grundeinstellungen
```lua
Config.Debug = false -- Debug-Nachrichten aktivieren/deaktivieren
Config.Locale = 'de' -- Sprache (de/en)
```

### Ped Einstellungen
```lua
Config.PedTimeout = 15 -- Zeit in Minuten bis zur Entfernung
Config.PedCheckInterval = 1 -- Prüfintervall in Minuten
Config.PedOffset = -1.0 -- Z-Offset für die Position
```

### Text Einstellungen
```lua
Config.TextSettings = {
    Font = 4,
    Scale = 0.35,
    Color = {r = 255, g = 255, b = 255, a = 255},
    DrawDistance = 15.0
}
```

### Namensanzeige
```lua
Config.NameDisplay = {
    Enabled = true,
    MaskLastname = true,
    MaskLength = 3,
    Format = "~y~Spieler Schläft\n~w~Name: %s"
}
```

## Admin Befehle

- `/fakesleep` - Erstellt einen Fake-Ped an deiner Position (Benötigt Admin-Rechte)

## Support

Bei Fragen oder Problemen stehe ich dir gerne zur Verfügung:
- Discord: AliOG1337

## Lizenz

Dieses Script ist urheberrechtlich geschützt. Jegliche Weiterverbreitung oder Modifikation ohne ausdrückliche Erlaubnis ist untersagt.

© 2024 AliOG. Alle Rechte vorbehalten.
"# ali_sleepoffline" 
