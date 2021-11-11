
local casinoPeds = {}


function playerEnterCasino()
    local src = source
    addPeds(src)
    luckyWheelPlayerEnter(src)
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

function BroadcastCasinoEvent(event, ...)
    for k,v in pairs(casinoPeds) do
        TriggerClientEvent(event, v, ...)
    end
end

AddEventHandler('playerDropped', function (reason)
    local src = source
    removePeds(src)
    slotsPlayerLeft(src)
    luckywheelPlayerLeft(src)
end)
