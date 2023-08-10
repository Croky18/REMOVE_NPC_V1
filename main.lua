--gemaakt door croky#8472--> bij problemen DM mijn op discord
--made by croky#8472--> if you have any problems DM my on discor

local currentVersion = "2.1" -- Huidige versie van je script/-- Current version of your script
local scriptUrl = "https://github.com/Croky18/clearareaNPC/blob/main/main.lua" --Niet Veranderen/--do not change

local function CheckForScriptUpdate()
    PerformHttpRequest(scriptUrl, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local lines = {}
            for line in resultData:gmatch("[^\r\n]+") do
                table.insert(lines, line)
            end

            local remoteVersion = lines[1]
            if remoteVersion and remoteVersion ~= currentVersion then
                print("A new version is available: " .. remoteVersion)
                print("Update available on: " .. scriptUrl)
            else
                print("You have the latest version of the script.")
            end
        else
            print("Error checking for updates.")
        end
    end, "GET", "", {})
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Controleer elke minuut op updates/-- Check for update every minutes

        CheckForScriptUpdate()
    end
end)

local zones = {
    {
        name = "zone1",
        center = vector3(-445.17, 6014.54, 31.72),
        distance = 16.0, -- Maximale afstand om als "in de zone" te worden beschouwd/--Maximum distance to be considered "in the zone"
        npcDelete = false, -- NPC's verwijderen in deze zone/--Remove NPCs in this zone
        vehicleDelete = false, -- Geparkeerde voertuigen verwijderen in deze zone/--Remove parked vehicles in this zone
    },
    
    -- Voeg meer zones toe zoals hierboven/-- Add more zones as above
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Wacht 1 seconde voordat opnieuw te controleren/---- Wait 1 second before checking again

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
