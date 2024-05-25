--gemaakt door happy_monkey6-> bij problemen DM mijn op discord
--made by happy_monkey6--> if you have any problems DM my on discor

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
        Citizen.Wait(100) -- Wacht 1 seconde voordat opnieuw te controleren/---- Wait 1 second before checking again

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
