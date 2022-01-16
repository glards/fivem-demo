
SlotMachines = {}

local payTable = {
    200,
    50,
    50,
    10,
    1000,
    200,
    1000,
    10
}

local slotMachinesTypes = {
    4,  -- 1 -> 10
    5,  -- 2 -> 1000
    6,  -- 3 -> 200
    7,  -- 4 -> 1000
    8,  -- 5 -> 10
    1,  -- 6 -> 200
    2,  -- 7 -> 50
    3,  -- 8 -> 50
    4,
    5,
    6,
    7,
    1,
    2,
    3,
    4,
    5,
    4,
    5,
    1,
    2,
    3,
    7,
    8,
    4,
    5,
    6,
    4,
    5,
    1,
    2,
    3,
    7,
    8,
    4,
    5,
    6,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
    3,
    4,
    5,
    1,
    2,
    6,
    7,
    8,
    4,
    5
}

local A = 1
local B = 2
local C = 3
local D = 4
local E = 5
local F = 6
local G = 7

local AA = 8
local AAA = 9

local symbolMultiplier = {
    [A] = 1.0,
    [AA] = 2.5,
    [AAA] = 250.0,
    [B] = 12.5,
    [C] = 25.0,
    [D] = 37.5,
    [E] = 50.0,
    [F] = 125.0,
    [G] = 500.0
}

local posToSymbol = {
    [0] = F,
    [1] = C,
    [2] = B,
    [3] = D,
    [4] = A,
    [5] = G,
    [6] = B,
    [7] = E,
    [8] = F,
    [9] = C,
    [10] = D,
    [11] = A,
    [12] = C,
    [13] = E,
    [14] = B,
    [15] = A
}

for k,v in pairs(slotMachinesTypes) do
    SlotMachines[k] = {
        id = k,
        occupied = false,
        type = v,
        play = 0,
        earn = 0.0,
        paid = 0.0
    }
end

function slotsHandling(id, event)
    local src = source

    if event == 'play' then
        clientPlaySlots(src, id, event)
    elseif event == 'enter' then
        clientEnterSlots(src, id, event)
    elseif event == 'leave' then
        clientLeaveSlots(src, id, event)
    else
        TriggerClientEvent('gl_casino:cl:slots', src, id, 'reset')
    end
end
RegisterNetEvent('gl_casino:sv:slots', slotsHandling)

function clientPlaySlots(src, id, event)
    if id < 1 or id > #SlotMachines then
        return
    end

    local slotMachine = SlotMachines[id]
    if slotMachine.ped ~= src then
        TriggerClientEvent('gl_casino:cl:slots', src, id, 'reset')
        return
    end

    slotMachine.play = slotMachine.play + 1

    local bet = payTable[slotMachine.type]
    slotMachine.earn = slotMachine.earn + bet
    
    
    Citizen.Wait(1500)

    BroadcastCasinoEvent('gl_casino:cl:slots', id, 'startSpinning')

    Citizen.Wait(2000)

    local reel1 = math.random(0, 15)
    local reel2 = math.random(0, 15)
    local reel3 = math.random(0, 15)

    local symbol1 = posToSymbol[reel1]
    local symbol2 = posToSymbol[reel2]
    local symbol3 = posToSymbol[reel3]

    local winningSymbol = nil
    local numberOfA = 0

    if symbol1 == A then
        numberOfA = numberOfA + 1
    end

    if symbol2 == A then
        numberOfA = numberOfA + 1
    end

    if symbol3 == A then
        numberOfA = numberOfA + 1
    end

    if numberOfA == 1 then
        winningSymbol = A
    end

    if numberOfA == 2 then
        winningSymbol = AA
    end

    if numberOfA == 3 then
        winningSymbol = AAA
    end

    if not winningSymbol then
        if symbol1 == symbol2 and symbol2 == symbol3 then
            winningSymbol = symbol1
        end
    end

    local won = 0
    if winningSymbol then
        local multiplier = symbolMultiplier[winningSymbol]
        won = bet*multiplier

        slotMachine.paid = slotMachine.paid + won

        print("SlotMachine won", slotMachine.id, won)
    end

    BroadcastCasinoEvent('gl_casino:cl:slots', id, 'stopSpinning', reel1, reel2, reel3, winningSymbol, won)
end

function clientEnterSlots(src, id, event)
    if id < 1 or id > #SlotMachines then
        return
    end

    local slotMachine = SlotMachines[id]
    if slotMachine.occupied and src ~= slotMachine.ped then
        TriggerClientEvent('gl_casino:cl:slots', src, id, 'reset')
        return
    end

    slotMachine.occupied = true
    slotMachine.ped = src
    BroadcastCasinoEvent('gl_casino:cl:slots', id, 'setOccupied', true)
end

function clientLeaveSlots(src, id, event)
    if id < 1 or id > #SlotMachines then
        return
    end

    local slotMachine = SlotMachines[id]
    if slotMachine.occupied and src == slotMachine.ped then
        slotMachine.occupied = false
        slotMachine.ped = nil
        BroadcastCasinoEvent('gl_casino:cl:slots', id, 'setOccupied', false)
    end
end

function slotsPlayerLeft(src)
    for k,v in pairs(SlotMachines) do
        if v.ped == src then
            v.occupied = false
            v.ped = nil
            BroadcastCasinoEvent('gl_casino:cl:slots', v.id, 'setOccupied', false)
        end
    end
end

RegisterCommand('slotStats', function(source, args, rawCommand)
    print("Slot machine stats:")
    for k,v in pairs(SlotMachines) do
        if v.earn ~= 0 then
            print("SlotMachine", v.id, v.play, v.earn, v.paid, v.earn - v.paid)
        end
    end
end, false)
