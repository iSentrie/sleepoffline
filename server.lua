local sleepingPeds = {}

local function Debug(msg, ...)
    if Config.Debug then
        print('^2[Ali_SleepOffline][SERVER] ^7' .. string.format(msg, ...))
    end
end

local function maskLastname(lastname)
    if not Config.NameDisplay.MaskLastname then
        return lastname
    end

    local visibleLength = math.min(Config.NameDisplay.MaskLength, #lastname)
    return lastname:sub(1, visibleLength) .. string.rep('*', #lastname - visibleLength)
end

local function getPlayerData(identifier, source, name)
    local skin = nil
    local playerName = Config.Locales[Config.Locale]['unknown']

    local skinResult = MySQL.Sync.fetchAll(string.format('SELECT %s FROM %s WHERE %s = @identifier',
        Config.MySQL.Tables.Fields.Skin,
        Config.MySQL.Tables.Users,
        Config.MySQL.Tables.Fields.Identifier
    ), {
        ['@identifier'] = identifier
    })

    if skinResult[1] and skinResult[1][Config.MySQL.Tables.Fields.Skin] then
        skin = json.decode(skinResult[1][Config.MySQL.Tables.Fields.Skin])
        Debug('Loaded skin data for player')
    else
        Debug('No skin data found for player')
    end

    if Config.NameDisplay.Mode == 'name' then
        local nameResult = MySQL.Sync.fetchAll(string.format('SELECT %s, %s FROM %s WHERE %s = @identifier',
            Config.MySQL.Tables.Fields.Firstname,
            Config.MySQL.Tables.Fields.Lastname,
            Config.MySQL.Tables.Users,
            Config.MySQL.Tables.Fields.Identifier
        ), {
            ['@identifier'] = identifier
        })

        if nameResult[1] then
            local lastname = maskLastname(nameResult[1][Config.MySQL.Tables.Fields.Lastname])
            playerName = string.format('%s %s',
                nameResult[1][Config.MySQL.Tables.Fields.Firstname],
                lastname
            )
            Debug('Got player name: %s', playerName)
        else
            Debug('No player name data found')
        end
    elseif Config.NameDisplay.Mode == 'license' then
        playerName = identifier:gsub("steam:", "")
        Debug('Using license as player name: %s', playerName)
    elseif Config.NameDisplay.Mode == 'id/name' then
        playerName = source .. ' | ' .. name
        Debug('Using source ID and player name: %s %s', source, name)
    elseif Config.NameDisplay.Mode == 'id/license' then
        playerName = source .. ' | ' .. identifier:gsub("steam:", "")
        Debug('Using source ID and identifier: %s %s', source, name)
    else
        Debug('Name display is disabled')
    end

    return skin, playerName
end

RegisterCommand(Config.Permissions.FakeCommandName, function(source)
    if source == 0 then return end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if not xPlayer.getGroup() == Config.Permissions.FakeCommand then
        Debug('Player %s tried to use test command without permission', source)
        return
    end

    Debug('Player dropped: %s', source)
    Debug('Player identifier: %s', xPlayer.identifier)

    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local name = GetPlayerName(source)
    local skin, playerName = getPlayerData(xPlayer.identifier, source, name)

    Debug('Saving sleeping ped data at coords: %s, %s, %s', coords.x, coords.y, coords.z)
    sleepingPeds[xPlayer.identifier] = {
        coords = coords,
        heading = heading,
        skin = skin,
        name = playerName,
        timestamp = os.time()
    }

    TriggerClientEvent('ali_sleepoffline:spawnSleepingPed', -1, xPlayer.identifier, coords, heading, skin, playerName)
end, false)

AddEventHandler('playerDropped', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    Debug('Player dropped: %s', source)

    if xPlayer then
        Debug('Player identifier: %s', xPlayer.identifier)
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        local name = GetPlayerName(source)
        local skin, playerName = getPlayerData(xPlayer.identifier, source, name)

        Debug('Saving sleeping ped data at coords: %s, %s, %s', coords.x, coords.y, coords.z)
        sleepingPeds[xPlayer.identifier] = {
            coords = coords,
            heading = heading,
            skin = skin,
            name = playerName,
            timestamp = os.time()
        }

        TriggerClientEvent('ali_sleepoffline:spawnSleepingPed', -1, xPlayer.identifier, coords, heading, skin, playerName)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    Debug('Player loaded: %s', source)

    if xPlayer then
        Debug('Player identifier: %s', xPlayer.identifier)
        if sleepingPeds[xPlayer.identifier] then
            Debug('Found sleeping ped for player, removing...')

            TriggerClientEvent('ali_sleepoffline:removeSleepingPed', -1, xPlayer.identifier)
            sleepingPeds[xPlayer.identifier] = nil
        else
            Debug('No sleeping ped found for player')
        end
    end
end)

local function removeOldPeds()
    local currentTime = os.time()
    local pedsRemoved = false

    for identifier, data in pairs(sleepingPeds) do
        if (currentTime - data.timestamp) > (Config.PedTimeout * 60) then
            Debug('Removing old ped for %s (timeout exceeded)', identifier)
            TriggerClientEvent('ali_sleepoffline:removeSleepingPed', -1, identifier)
            sleepingPeds[identifier] = nil
            pedsRemoved = true
        end
    end

    return pedsRemoved
end

CreateThread(function()
    while true do
        Wait(Config.PedCheckInterval * 60 * 1000)
        removeOldPeds()
    end
end)

ESX.RegisterServerCallback('ali_sleepoffline:getSleepingPeds', function(source, cb)
    Debug('Sending sleeping peds data to client: %s', source)
    cb(sleepingPeds)
end)
