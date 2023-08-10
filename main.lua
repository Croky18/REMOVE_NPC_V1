local currentVersion = "2.0" -- Huidige versie van je script
local scriptUrl = "https://github.com/Croky18/clearareaNPC/blob/main/main.lua" -- URL naar je GitHub-scriptbestand

local function CheckForScriptUpdate()
    PerformHttpRequest(scriptUrl, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local lines = {}
            for line in resultData:gmatch("[^\r\n]+") do
                table.insert(lines, line)
            end

            local remoteVersion = lines[1]
            if remoteVersion and remoteVersion ~= currentVersion then
                print("Er is een nieuwe versie beschikbaar: " .. remoteVersion)
                print("Update beschikbaar op: " .. scriptUrl)
            else
                print("Je hebt de nieuwste versie van het script.")
            end
        else
            print("Fout bij het controleren op updates.")
        end
    end, "GET", "", {})
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Controleer elke minuut op updates

        CheckForScriptUpdate()
    end
end)

-- Rest van je script hier...

local zones = {
    {
        name = "zone1",
        center = vector3(-445.17, 6014.54, 31.72),
        distance = 16.0, -- Maximale afstand om als "in de zone" te worden beschouwd
        npcDelete = true, -- NPC's verwijderen in deze zone
        vehicleDelete = false, -- Geparkeerde voertuigen verwijderen in deze zone
    },
    
    -- Voeg meer zones toe zoals hierboven
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Wacht 1 seconde voordat opnieuw te controleren

        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for _, zone in ipairs(zones) do
            local distanceToZone = #(zone.center - playerCoords)

            if distanceToZone <= zone.distance then
                DeleteEntitiesInZone(zone)
            end
        end
    end
end)

function DeleteEntitiesInZone(zone)
    if zone.npcDelete then
        local peds = GetGamePool('CPed')
        for _, ped in ipairs(peds) do
            local pedCoords = GetEntityCoords(ped)
            local distanceToZone = #(zone.center - pedCoords)
            if distanceToZone <= zone.distance then
                DeleteEntity(ped)
            end
        end
    end

    if zone.vehicleDelete then
        local vehicles = GetGamePool('CVehicle')
        for _, vehicle in ipairs(vehicles) do
            local vehicleCoords = GetEntityCoords(vehicle)
            local distanceToZone = #(zone.center - vehicleCoords)
            if distanceToZone <= zone.distance and not IsPedInAnyVehicle(vehicle, false) then
                DeleteEntity(vehicle)
            end
        end
    end
end
