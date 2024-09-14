local spawnedBike = nil

-- Spawning a bike under the player with a fixed grey color
function spawnSpecificBike(bikeModel)
    if spawnedBike ~= nil then
      --  print("[DEBUG] A bike is already spawned.") -- Debug message
        return -- If a bike already exists, don't spawn a new one
    end

   -- print("[DEBUG] Loading bike model: " .. bikeModel) -- Debug message

    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    
    local bikeModelHash = GetHashKey(bikeModel)

    -- Load the model
    RequestModel(bikeModelHash)
    while not HasModelLoaded(bikeModelHash) do
        Wait(500)
    end

    -- Spawn the bike under the player
    spawnedBike = CreateVehicle(bikeModelHash, playerPos.x, playerPos.y, playerPos.z, GetEntityHeading(playerPed), true, false)
    
    -- Set the color of the bike to grey (both primary and secondary)
    local primaryColor = 4  -- Silver (grey)
    local secondaryColor = 4 -- Silver (grey)

    SetVehicleColours(spawnedBike, primaryColor, secondaryColor)

    -- Place the player on the bike
    TaskWarpPedIntoVehicle(playerPed, spawnedBike, -1)
end

-- Removing the bike
function removeBike()
    if spawnedBike and DoesEntityExist(spawnedBike) then
       -- print("[DEBUG] Removing bike") -- Debug message
        DeleteVehicle(spawnedBike)
        spawnedBike = nil
    end
end

-- Checking if the player dismounts and removing the bike
Citizen.CreateThread(function()
    while true do
        Wait(1000) -- Check every second

        local playerPed = PlayerPedId()

        if spawnedBike and DoesEntityExist(spawnedBike) then
            if not IsPedInVehicle(playerPed, spawnedBike, false) then
                -- If the player is not on the bike, remove it
                removeBike()
            end
        end
    end
end)

-- Receiving the event from the server with the bike model
RegisterNetEvent('useSpecificBike')
AddEventHandler('useSpecificBike', function(bikeModel)
    --print("[DEBUG] Event received: " .. bikeModel) -- Debug message
    spawnSpecificBike(bikeModel)
end)

--[[
-- For testing: manually spawn a bike with a command
RegisterCommand('spawnbike', function()
    spawnSpecificBike('bmx') -- By default, spawn the BMX model
end, false)
]]
