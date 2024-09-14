local ESX = nil
local QBCore = nil

-- Selecting the framework based on the configuration
local framework = Config.Framework

if framework == 'esx' then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
else
   -- print("[ERROR] Invalid framework setting in the config.lua file.")
end

-- Registering bike item usage events
local function registerItemUsage(itemName, bikeModel)
    if framework == 'esx' then
        ESX.RegisterUsableItem(itemName, function(source)
            local xPlayer = ESX.GetPlayerFromId(source)
          --  print("[DEBUG] " .. itemName .. " item usage started!") -- Debug message
            TriggerClientEvent('useSpecificBike', source, bikeModel)
        end)
    elseif framework == 'qbcore' then
        QBCore.Functions.CreateUseableItem(itemName, function(source)
            local Player = QBCore.Functions.GetPlayer(source)
          --  print("[DEBUG] " .. itemName .. " item usage started!") -- Debug message
            TriggerClientEvent('useSpecificBike', source, bikeModel)
        end)
    end
end

-- Register each bike type
registerItemUsage('bmx', 'bmx')
registerItemUsage('cruiser', 'cruiser')
registerItemUsage('fixter', 'fixter')
registerItemUsage('scorcher', 'scorcher')
registerItemUsage('tribike', 'tribike')
registerItemUsage('tribike2', 'tribike2')
registerItemUsage('tribike3', 'tribike3')
