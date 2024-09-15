local spawnedBike = nil

-- Spawning a bike under the player with assembly animation
function spawnSpecificBike(bikeModel)
    if spawnedBike ~= nil then
        -- print("[DEBUG] A bike is already spawned.") -- Debug message
        return -- If a bike already exists, don't spawn a new one
    end

    -- print("[DEBUG] Playing assembly animation") -- Debug message
    playAssemblyAnimation() -- Play the assembly animation

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

-- Removing the bike with assembly animation
function removeBike()
    if spawnedBike and DoesEntityExist(spawnedBike) then
        -- print("[DEBUG] Playing disassembly animation") -- Debug message
        playAssemblyAnimation() -- Play the assembly animation

        -- After the animation, remove the bike
        -- print("[DEBUG] Removing the bike") -- Debug message
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

-- Play the assembly animation and stop it after 3 seconds
function playAssemblyAnimation()
    local playerPed = PlayerPedId()
    RequestAnimDict("mini@repair")

    -- Wait until the animation dictionary is loaded
    while not HasAnimDictLoaded("mini@repair") do
        Wait(100)
    end

    -- Play the assembly animation (looped for safety, but we'll stop it manually)
    TaskPlayAnim(playerPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 49, 0, false, false, false)

    -- Wait for 3 seconds (animation duration)
    Wait(3000)

    -- Stop the animation after 3 seconds
    ClearPedTasks(playerPed)
end

--[[
-- For testing: manually spawn a bike with a command
RegisterCommand('spawnbike', function()
    spawnSpecificBike('bmx') -- By default, spawn the BMX model
end, false)
]]
