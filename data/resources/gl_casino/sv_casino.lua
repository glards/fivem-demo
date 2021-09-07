
local casinoPeds = {}

local wheelPos = 1
local wheelSpinning = false

function playerEnterCasino()
    local src = source
    addPeds(src)
    TriggerClientEvent('gl_casino:luckywheel:setSpin', src, wheelPos)
end

function playerLeaveCasino()
    removePeds(source)
end

function addPeds(ped)
    local newPeds = {}
    for k,v in pairs(casinoPeds) do
        if v ~= ped then
            table.insert(newPeds, v)
        end
    end
    table.insert(newPeds, ped)
    casinoPeds = newPeds
end

function removePeds(ped)
    local newPeds = {}
    for k,v in pairs(casinoPeds) do
        if v ~= ped then
            table.insert(newPeds, v)
        end
    end
    casinoPeds = newPeds
end

RegisterNetEvent('gl_casino:playerEnterCasino', playerEnterCasino)
RegisterNetEvent('gl_casino:playerLeaveCasino', playerLeaveCasino)


RegisterCommand('setWheel', function(source, args, rawCommand)
    wheelPos = tonumber(args[1]) or 1
end, false)
