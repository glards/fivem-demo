
SlotMachines = {}

for i=1, 54 do
    SlotMachines[i] = {
        id = i,
        occupied = false,
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
    
    Citizen.Wait(2000)

    BroadcastCasinoEvent('gl_casino:cl:slots', id, 'startSpinning')

    local reel1 = math.random(0, 15)
    local reel2 = math.random(0, 15)
    local reel3 = math.random(0, 15)

    if reel1 == reel2 and reel2 == reel3 then
    end

    Citizen.Wait(2000)

    BroadcastCasinoEvent('gl_casino:cl:slots', id, 'stopSpinning', reel1, reel2, reel3)
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