local running = false

local wheel = nil

local wheelPos = 0
local wheelOccupied = false
local wheelSpinning = false
local wheelTarget = nil

local currentState = nil

local animDicts = {
    "ANIM_CASINO_A@AMB@CASINO@GAMES@LUCKY7WHEEL@FEMALE",
    "ANIM_CASINO_A@AMB@CASINO@GAMES@LUCKY7WHEEL@MALE"
}

local anims = {
    "Enter_to_ArmRaisedIDLE",               -- 1
    "ArmRaisedIDLE",                        -- 2
    "ArmRaisedIDLE_to_SpinReadyIDLE",       -- 3
    "SpinReadyIDLE",                        -- 4
    "SpinStart_ArmRaisedIDLE_to_BaseIDLE",  -- 5
    "spinreadyidle_to_spinningidle_low",    -- 6
    "ArmRaisedIDLE_to_SpinningIDLE_Low",    -- 7
    "spinreadyidle_to_spinningidle_med",    -- 8
    "ArmRaisedIDLE_to_SpinningIDLE_Med",    -- 9
    "spinreadyidle_to_spinningidle_high",   -- 10
    "ArmRaisedIDLE_to_SpinningIDLE_High",   -- 11
    "SpinningIDLE_Low",                     -- 12
    "SpinningIDLE_Medium",                  -- 13
    "SpinningIDLE_High",                    -- 14
    "Win",                                  -- 15
    "Win_Big",                              -- 16
    "Win_Huge",                             -- 17
    "Exit_to_Standing",                     -- 18
    "SpinReadyIDLE_to_ArmRaisedIDLE"        -- 19
}

local animOffsets = {
    10,
    6,
    5
}

local wheelPosition = 1

local wheelAnims = {
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

local luckyWheelHashes = {
    `vw_prop_vw_luckywheel_02a`
}

local luckyWheelAnimPos = vector3(1111.052, 229.8492, -50.6409)
local luckyWheelAnimRot = vector3(0.0, 0.0, 0.0)
local luckyWheelCirclePos = vector3(1111.12, 228.55, -49.64)

local INPUT_ENTER = 23
local INPUT_CONTEXT = 51
local INPUT_CONTEXT_SECONDARY = 52

local function getAnimDict(ped)
    local dict = 1
    if IsPedMale(ped) then
        dict = 2
    end
    return animDicts[dict]
end

local function streamAssets()
    exports.gl_utils:loadModels(luckyWheelHashes)
    exports.gl_utils:loadAnimDicts(animDicts)
end

function startLuckyWheel()
    if running then
        return
    end

    running = true

    streamAssets()

    if wheel then
        DeleteEntity(wheel)
    end
    
    local hash = luckyWheelHashes[1]
    wheel = CreateObjectNoOffset(hash, vector3(1111.052, 229.8579, -49.133), false, false, true)
    SetEntityCanBeDamaged(wheel, false)

    Citizen.CreateThread(luckyWheelPlayerThread)
    Citizen.CreateThread(luckyWheelThread)
end

function stopLuckyWheel()
    if not running then
        return
    end

    running = false

    DeleteEntity(wheel)
    wheel = nil
end

function luckyWheelPlayerThread()
    local ped = PlayerPedId()

    currentState = LuckyWheel_InsideCasino

    while running do
        Citizen.Wait(0)

        local timer = GetGameTimer()
        local coords = GetEntityCoords(ped)

        if currentState then
            currentState(ped, coords, timer)
        end
    end
end

function luckyWheelThread()
    while running do
        Citizen.Wait(0)
    end
end

function LuckyWheel_InsideCasino(ped, coords, timer)
    if not wheelOccupied and #(coords - luckyWheelCirclePos) < 2.0 then
        exports.gl_utils:drawNotification("Appuyer sur ~INPUT_ENTER~ pour jouer à la roue de la chance")

        local enterPressed = IsControlJustPressed(0, INPUT_ENTER)
        if enterPressed then
            currentState = LuckyWheel_PlayAnim
            TriggerServerEvent('gl_casino:luckywheel:takeWheel')
        end
    end
end

function LuckyWheel_PlayAnim(ped, coords, timer)
    local animDict = getAnimDict(ped)
    local anim = anims[1]

    local animPos = GetAnimInitialOffsetPosition(animDict, anim, luckyWheelAnimPos, luckyWheelAnimRot, 0.0, 2)
    local animRot = GetAnimInitialOffsetRotation(animDict, anim, luckyWheelAnimPos, luckyWheelAnimRot, 0.0, 2)

    local duration = 5 -- or 69
    local flag = 0
    local playbackRate = 1000.0
    local holdLastFrame = true
    local looped = false

    Citizen.Await(exports.gl_utils:followNavMesh(ped, animPos, luckyWheelAnimRot.z))

    Citizen.CreateThread(playWheel)
    Citizen.Await(exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim, luckyWheelAnimPos, luckyWheelAnimRot, holdLastFrame, looped, 8.0, 8.0, duration, flag, playbackRate))

    anim = anims[11]
    Citizen.Await(exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim, luckyWheelAnimPos, luckyWheelAnimRot, holdLastFrame, looped, 8.0, 8.0, duration, flag, playbackRate))

    -- anim = anims[14]
    -- Citizen.Await(exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim, luckyWheelAnimPos, luckyWheelAnimRot, holdLastFrame, looped, 8.0, 8.0, duration, flag, playbackRate))

    ClearPedTasks(ped)

    currentState = LuckyWheel_InsideCasino
end

local WHEEL_DELAY = 2450
function playWheel()
    wheelSpinning = true
    Citizen.Wait(WHEEL_DELAY)
    TriggerServerEvent('gl_casino:luckywheel:spinWheel')
    startSpinning()
end

function nextPos(pos)
    pos = pos - 1

    if pos < 1 then
        pos = 20
    end
    if pos > 20 then
        pos = 1
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

    local rot = (pos-1)*18.0
    if rot < 0.0 then
        rot = rot + 360.0
    end
    return rot
end

local SPIN_DELAY_START = 120.0
local SPIN_DELAY_NORMAL = 60.0
local SPIN_DELAY_SLOWING = 100.0
local SPIN_DELAY_STOPPING = 150.0

function startSpinning()
    local ped = PlayerPedId()

    --wheelPosition = playWheelAnim(ped, wheel, 3, wheelPosition)

    local current = GetGameTimer()
    local delay = SPIN_DELAY_START
    local nextTime = current + math.ceil(delay)

    local spinning = true
    local slowing = false
    local stopping = false

    local posCount = 0
    local lastTurn = 0

    local turnSlowing = 2
    local turnStopping = 1

    while spinning do
        local currentRot = posToRot(wheelPosition)
        local nextWheelPosition = nextPos(wheelPosition)
        local nextRot = posToRot(nextWheelPosition)

        if nextRot > currentRot then
            currentRot = currentRot + 360.0
        end

        while nextTime > current do
            local ratio = 1.0-((nextTime-current)/delay)
            local rot = currentRot + (nextRot - currentRot)*ratio
            SetEntityRotation(wheel, 0.0, rot, 0.0, 2, true)
            Citizen.Wait(0)

            current = GetGameTimer()
        end

        posCount = posCount + 1

        if delay == SPIN_DELAY_START and posCount > 4 then
            delay = SPIN_DELAY_NORMAL
        end

        local turn = posCount // 20
        wheelPosition = nextWheelPosition
        local isNewTurn = turn ~= lastTurn

        lastTurn = turn

        if isNewTurn then
            if delay == SPIN_DELAY_NORMAL then
                if wheelTarget then
                    delay = SPIN_DELAY_SLOWING
                end
            elseif delay == SPIN_DELAY_SLOWING then
                turnSlowing = turnSlowing - 1
                if turnSlowing == 0 then
                    delay = SPIN_DELAY_STOPPING
                end
            elseif delay == SPIN_DELAY_STOPPING then
                turnStopping = turnStopping - 1
                if turnStopping == 0 then
                    stopping = true
                end
            end
        end
        nextTime = current + math.ceil(delay)


        if stopping and wheelPosition == wheelTarget then
            spinning = false
        end
    end

    wheelPosition = wheelTarget
    wheelTarget = nil
    SetEntityRotation(wheel, 0.0, posToRot(wheelPosition), 0.0, 2, true)
end


RegisterNetEvent('gl_casino:luckywheel:setSpin')
AddEventHandler('gl_casino:luckywheel:setSpin', function(pos)
    local rot = posToRot(pos)

    SetEntityRotation(wheel, 0.0, rot, 0.0, 2, true)
end)

local function luckywheelStartSpinning()
    if not wheelSpinning then
        startSpinning()
    end
end
RegisterNetEvent('gl_casino:luckywheel:startSpinning', luckywheelStartSpinning)

local function luckywheelStopSpinning(pos)
    wheelTarget = pos
    wheelSpinning = false
end
RegisterNetEvent('gl_casino:luckywheel:stopSpinning', luckywheelStopSpinning)

local function luckywheelSetOccupied(occupied)
    wheelOccupied = occupied
end
RegisterNetEvent('gl_casino:luckywheel:setOccupied', luckywheelSetOccupied)

local function luckywheelReset()
    currentState = LuckyWheel_InsideCasino
    wheelTarget = nil
end
RegisterNetEvent('gl_casino:luckywheel:reset', luckywheelReset)
