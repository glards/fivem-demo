
local wheelPos = 1
local wheelPed = nil


function luckyWheelPlayerEnter(src)
    TriggerClientEvent('gl_casino:luckywheel:setSpin', src, wheelPos)
end

local function playerTakeWheel()
    local src = source
    if wheelPed then
        TriggerClientEvent('gl_casino:luckywheel:reset', src)
        return
    end

    wheelPed = src

    BroadcastCasinoEvent('gl_casino:luckywheel:setOccupied', true)
end
RegisterNetEvent('gl_casino:luckywheel:takeWheel', playerTakeWheel)


local function playerSpinWheel()
    local src = source
    if wheelPed ~= src then
        TriggerClientEvent('gl_casino:cl:luckywheel:reset', src)
        return
    end

    BroadcastCasinoEvent('gl_casino:luckywheel:startSpinning')

    Citizen.Wait(10000)
    
    wheelPos = math.random(1, 20)
    BroadcastCasinoEvent('gl_casino:luckywheel:stopSpinning', wheelPos)

    Citizen.Wait(2*20*100 + 1*20*150 + 3000)

    wheelPed = nil
    BroadcastCasinoEvent('gl_casino:luckywheel:setOccupied', false)
end
RegisterNetEvent('gl_casino:luckywheel:spinWheel', playerSpinWheel)

function luckywheelPlayerLeft(src)
end
