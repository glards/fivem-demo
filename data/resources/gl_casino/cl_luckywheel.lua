local wheel = nil
local animDict = "ANIM_CASINO_A@AMB@CASINO@GAMES@LUCKY7WHEEL@MALE"

local animOffsets = {
    10,
    6,
    5
}

local wheelPosition = 1

local animNames = {
    {
        "spinningwheel_high_effort_01",
        "spinningwheel_high_effort_02",
        "spinningwheel_high_effort_03",
        "spinningwheel_high_effort_04",
        "spinningwheel_high_effort_05",
        "spinningwheel_high_effort_06",
        "spinningwheel_high_effort_07",
        "spinningwheel_high_effort_08",
        "spinningwheel_high_effort_09",
        "spinningwheel_high_effort_10",
        "spinningwheel_high_effort_11",
        "spinningwheel_high_effort_12",
        "spinningwheel_high_effort_13",
        "spinningwheel_high_effort_14",
        "spinningwheel_high_effort_15",
        "spinningwheel_high_effort_16",
        "spinningwheel_high_effort_17",
        "spinningwheel_high_effort_18",
        "spinningwheel_high_effort_19",
        "spinningwheel_high_effort_20"
    },
    {
        "spinningwheel_med_effort_01",
        "spinningwheel_med_effort_02",
        "spinningwheel_med_effort_03",
        "spinningwheel_med_effort_04",
        "spinningwheel_med_effort_05",
        "spinningwheel_med_effort_06",
        "spinningwheel_med_effort_07",
        "spinningwheel_med_effort_08",
        "spinningwheel_med_effort_09",
        "spinningwheel_med_effort_10",
        "spinningwheel_med_effort_11",
        "spinningwheel_med_effort_12",
        "spinningwheel_med_effort_13",
        "spinningwheel_med_effort_14",
        "spinningwheel_med_effort_15",
        "spinningwheel_med_effort_16",
        "spinningwheel_med_effort_17",
        "spinningwheel_med_effort_18",
        "spinningwheel_med_effort_19",
        "spinningwheel_med_effort_20"
    },
    {
        "spinningwheel_low_effort_01",
        "spinningwheel_low_effort_02",
        "spinningwheel_low_effort_03",
        "spinningwheel_low_effort_04",
        "spinningwheel_low_effort_05",
        "spinningwheel_low_effort_06",
        "spinningwheel_low_effort_07",
        "spinningwheel_low_effort_08",
        "spinningwheel_low_effort_09",
        "spinningwheel_low_effort_10",
        "spinningwheel_low_effort_11",
        "spinningwheel_low_effort_12",
        "spinningwheel_low_effort_13",
        "spinningwheel_low_effort_14",
        "spinningwheel_low_effort_15",
        "spinningwheel_low_effort_16",
        "spinningwheel_low_effort_17",
        "spinningwheel_low_effort_18",
        "spinningwheel_low_effort_19",
        "spinningwheel_low_effort_20"
    }
}

Citizen.CreateThread(function()
    local hash = `vw_prop_vw_luckywheel_02a`

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end

    wheel = CreateObjectNoOffset(hash, vector3(1111.052, 229.8579, -49.133), false, false, true)
    SetEntityCanBeDamaged(wheel, false)
end)

function playWheelAnim(wheel, force, wheelPosition)
    local prevPosition = wheelPosition
    local anim = animNames[force][wheelPosition]

    SetEntityRotation(wheel, 0.0, 0.0, 0.0, 2, true)
    PlayEntityAnim(wheel, anim, animDict, 1.0, false, true, false, 0.0, 2)
    ForceEntityAiAndAnimationUpdate(wheel)
    Citizen.Wait(0)
    while IsEntityPlayingAnim(wheel, animDict, anim, 3) and GetEntityAnimCurrentTime(wheel, animDict, anim) ~= 1.0 do
        Citizen.Wait(0)
    end
    StopEntityAnim(wheel, anim, animDict, -8.0)
    wheelPosition = (prevPosition + animOffsets[force]) % 20

    return wheelPosition
end


function nextPos(pos)
    pos = pos - 1
    if pos < 1 then
        pos = 20
    end
    return pos
end

function posToRot(pos)
    if pos < 1 then
        pos = 1
    end

    if pos > 20 then
        pos = 20
    end

    local rot = (pos-1)*-18.0
    if rot < 0.0 then
        rot = rot + 360.0
    end
    return rot
end


RegisterCommand('spin', function(source, args, rawCommand)
    --wheelPosition = 1
    print("Start spinning", wheelPosition)

    wheelPosition = playWheelAnim(wheel, 3, wheelPosition)

    local current = GetGameTimer()
    local backoff = current + 2000 + math.random(1, 1500)
    local stopTime = current + 2500 + math.random(1, 1500)
    local delay = 50.0
    local nextTime = current + math.ceil(delay)
    local spinning = true
    while spinning do
        local currentRot = posToRot(wheelPosition)
        local nextWheelPosition = nextPos(wheelPosition)
        local nextRot = posToRot(nextWheelPosition)

        print("Continue spinning", wheelPosition)
        while nextTime > current do
            local ratio = (nextTime-current)/delay
            SetEntityRotation(wheel, 0.0, rot, 0.0, 2, true)
            Citizen.Wait(0)

            current = GetGameTimer()
        end

        if current > backoff then
            delay = delay * 1.5
        end

        wheelPosition = wheelPosition - 1
        if wheelPosition < 1 then
            wheelPosition = 20
        end
        nextTime = current + math.ceil(delay)

        if current > stopTime then
            spinning = false
        end
    end

    print("Stopped spinning", wheelPosition)

    -- for i=1,3 do
    --     wheelPosition = playWheelAnim(wheel, i, wheelPosition)
    --     print("Continue spinning", wheelPosition)
    -- end
    -- wheelPosition = playWheelAnim(wheel, 3, wheelPosition)
    -- print("Stopped spinning", wheelPosition)
    --
end, false)

RegisterCommand('wheel', function(source, args, rawCommand)
    local idx = tonumber(args[1]) or 1
    local rot = posToRot(idx)

    SetEntityRotation(wheel, 0.0, rot, 0.0, 2, true)
    wheelPosition = idx
end, false)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteEntity(wheel)
        wheel = nil
    end
end)

RegisterNetEvent('gl_casino:luckywheel:setSpin')
AddEventHandler('gl_casino:luckywheel:setSpin', function(pos)
    local rot = posToRot(pos)

    SetEntityRotation(wheel, 0.0, rot, 0.0, 2, true)
end)

RegisterNetEvent('gl_casino:luckywheel:spinTo')
AddEventHandler('gl_casino:luckywheel:spinTo', function(pos)
end)

