
local wheelPos = 1
local wheelSpinning = false
local wheelOccupied = false
local wheelPed = nil


RegisterCommand('setWheel', function(source, args, rawCommand)
    wheelPos = tonumber(args[1]) or 1
end, false)

function luckyWheelPlayerEnter(src)
    TriggerClientEvent('gl_casino:luckywheel:setSpin', src, wheelPos)
end


function luckyWheelHandling(event)
    local src = source

    if event == 'play' then
        clientPlayLuckyWheel(src, event)
    elseif event == 'enter' then
        clientEnterLuckyWheel(src, event)
    elseif event == 'leave' then
        clientLeaveLuckyWheel(src, event)
    else
        TriggerClientEvent('gl_casino:cl:luckyWheel', src, 'reset')
    end
end

RegisterNetEvent('gl_casino:sv:luckyWheel', slotsHandling)

function clientPlayLuckyWheel(src, event)
    if wheelPed ~= src then
        TriggerClientEvent('gl_casino:cl:luckyWheel', src, 'reset')
        return
    end

    BroadcastCasinoEvent('gl_casino:cl:luckyWheel', 'startSpinning')

    Citizen.Wait(10000)
    
    wheelPos = math.random(1, 20)
    BroadcastCasinoEvent('gl_casino:cl:luckyWheel', 'stopSpinning', wheelPos)
end


function clientEnterLuckyWheel(src, event)
    if wheelPed then
        TriggerClientEvent('gl_casino:cl:luckyWheel', src, 'reset')
        return
    end

    wheelOccupied = true
    wheelPed = src

    BroadcastCasinoEvent('gl_casino:cl:luckyWheel', 'setOccupied', true)
end

function clientLeaveLuckyWheel(src, event)
    if wheelPed ~= src then
        return
    end

    wheelOccupied = false
    wheelPed = nil

    BroadcastCasinoEvent('gl_casino:cl:luckyWheel', 'setOccupied', false)
end

function luckywheelPlayerLeft(src)
    if wheelPed == src then
        wheelOccupied = false
        wheelPed = nil
    
        BroadcastCasinoEvent('gl_casino:cl:luckyWheel', 'setOccupied', false)
    end
end