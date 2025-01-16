local activePeds = {}
local activeNames = {}

local function _U(str, ...)
    local text = Config.Locales[Config.Locale][str]
    if text == nil then
        return 'Translation_Missing: ' .. Config.Locale .. '/' .. str
    end
    return string.format(text, ...)
end

local function Debug(msg, ...)
    if Config.Debug then
        print('^3[Ali_SleepOffline][CLIENT] ^7' .. string.format(msg, ...))
    end
end

local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * Config.TextSettings.Scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, Config.TextSettings.Scale * scale)
        SetTextFont(Config.TextSettings.Font)
        SetTextProportional(1)
        SetTextColour(
            Config.TextSettings.Color.r,
            Config.TextSettings.Color.g,
            Config.TextSettings.Color.b,
            Config.TextSettings.Color.a
        )
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

local function CreateSleepingPed(identifier, coords, heading, skin)
    Debug('Creating sleeping ped for %s at coords: %s, %s, %s', identifier, coords.x, coords.y, coords.z)

    if activePeds[identifier] then
        Debug('Removing existing ped for %s', identifier)
        DeleteEntity(activePeds[identifier])
        activePeds[identifier] = nil
    end

    local modelHash = joaat(skin.model) or `mp_m_freemode_01`
    Debug('Loading model: %s', modelHash)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end

    local ped = CreatePed(4, modelHash, coords.x, coords.y, coords.z + Config.PedOffset, heading, false, true)
    activePeds[identifier] = ped
    Debug('Created ped with handle: %s', ped)

    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanBeTargetted(ped, false)
    SetEntityCollision(ped, false, false)

    if skin then
        Debug('Applying skin to ped')
        Debug('Full skin data:')
        for k,v in pairs(skin) do
            Debug('  %s = %s', k, v)
        end

        local headBlend = skin.headBlend
        SetPedHeadBlendData(ped, headBlend.shapeFirst, headBlend.shapeSecond, headBlend.shapeThird, headBlend.skinFirst, headBlend.skinSecond, headBlend.skinThird, headBlend.shapeMix, headBlend.skinMix, headBlend.thirdMix, false)

        for feature, value in pairs(skin.faceFeatures) do
            SetPedFaceFeature(ped, feature, value)
        end

        for overlay, data in pairs(skin.headOverlays) do
            SetPedHeadOverlay(ped, overlay, data.style, data.opacity)
            SetPedHeadOverlayColor(ped, overlay, 1, data.color, data.secondColor)
        end

        if skin.hair then
            SetPedComponentVariation(ped, 2, skin.hair.style, skin.hair.texture or 0, 0) -- Hair
            SetPedHairColor(ped, skin.hair.color, skin.hair.highlight)
        end

        for _, component in ipairs(skin.components) do
            SetPedComponentVariation(ped, component.component_id, component.drawable, component.texture, 0)
        end

        for _, prop in ipairs(skin.props) do
            if prop.drawable == -1 then
                ClearPedProp(ped, prop.prop_id)
            else
                SetPedPropIndex(ped, prop.prop_id, prop.drawable, prop.texture or 0, true)
            end
        end

        SetPedEyeColor(ped, skin.eyeColor)
    end

    Debug('Loading sleep animation')
    RequestAnimDict(Config.Animation.Dict)
    while not HasAnimDictLoaded(Config.Animation.Dict) do
        Wait(0)
    end

    TaskPlayAnim(ped, Config.Animation.Dict, Config.Animation.Name,
        Config.Animation.BlendIn, Config.Animation.BlendOut, -1,
        Config.Animation.Flag, 0, false, false, false)
    Debug('Animation started')

    SetModelAsNoLongerNeeded(modelHash)
end

RegisterNetEvent('ali_sleepoffline:spawnSleepingPed')
AddEventHandler('ali_sleepoffline:spawnSleepingPed', function(identifier, coords, heading, skin, playerName)
    Debug('Received spawnSleepingPed event for %s (%s)', identifier, playerName)
    CreateSleepingPed(identifier, coords, heading, skin)
    activeNames[identifier] = playerName
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for identifier, ped in pairs(activePeds) do
            if DoesEntityExist(ped) then
                local pedCoords = GetEntityCoords(ped)
                local dist = #(playerCoords - pedCoords)

                if dist < Config.TextSettings.DrawDistance then
                    sleep = 0
                    local name = activeNames[identifier] or _U('unknown')
                    local displayText = string.format(Config.NameDisplay.Format, name)
                    DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z - 0.5, displayText)
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('ali_sleepoffline:removeSleepingPed')
AddEventHandler('ali_sleepoffline:removeSleepingPed', function(identifier)
    Debug('Received removeSleepingPed event for %s', identifier)
    if activePeds[identifier] then
        DeleteEntity(activePeds[identifier])
        activePeds[identifier] = nil
        activeNames[identifier] = nil
        Debug('Removed ped and name for %s', identifier)
    else
        Debug('No ped found to remove for %s', identifier)
    end
end)

AddEventHandler('playerSpawned', function()
    Debug('Player spawned, requesting sleeping peds data')
    ESX.TriggerServerCallback('ali_sleepoffline:getSleepingPeds', function(sleepingPeds)
        Debug('Received %s sleeping peds', #sleepingPeds)
        for identifier, data in pairs(sleepingPeds) do
            CreateSleepingPed(identifier, data.coords, data.heading, data.skin)
            activeNames[identifier] = data.name
        end
    end)
end)
