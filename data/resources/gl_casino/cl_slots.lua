
local seats = {
    vector3(1101.01, 229.876, -50.8409),
    vector3(1101.59, 230.626, -50.8409),
    vector3(1101.95, 231.501, -50.8409),
    vector3(1102.08, 232.433, -50.8409),
    vector3(1101.96, 233.367, -50.8409),
    vector3(1108.41, 238.946, -50.8409),
    vector3(1109.16, 238.376, -50.8409),
    vector3(1110.03, 238.016, -50.8409),
    vector3(1110.97, 237.89, -50.8409),
    vector3(1111.91, 238.012, -50.8409),
    vector3(1112.78, 238.371, -50.8409),
    vector3(1113.53, 238.943, -50.8409),
    vector3(1120.13, 233.355, -50.8409),
    vector3(1120, 232.427, -50.8409),
    vector3(1120.13, 231.494, -50.8409),
    vector3(1120.48, 230.624, -50.8409),
    vector3(1121.06, 229.878, -50.8409),
    vector3(1104.13, 228.836, -50.8409),
    vector3(1103.59, 230.55, -50.8409),
    vector3(1105.05, 231.597, -50.8409),
    vector3(1106.5, 230.53, -50.8409),
    vector3(1105.93, 228.823, -50.8409),
    vector3(1107.56, 233.308, -50.8409),
    vector3(1107.02, 235.023, -50.8409),
    vector3(1108.48, 236.07, -50.8409),
    vector3(1109.93, 235.003, -50.8409),
    vector3(1109.36, 233.297, -50.8409),
    vector3(1113.2, 233.067, -50.8409),
    vector3(1112.65, 234.78, -50.8409),
    vector3(1114.11, 235.828, -50.8409),
    vector3(1115.56, 234.76, -50.8409),
    vector3(1115, 233.054, -50.8409),
    vector3(1116.22, 228.28, -50.8409),
    vector3(1115.68, 229.995, -50.8409),
    vector3(1117.14, 231.042, -50.8409),
    vector3(1118.59, 229.975, -50.8409),
    vector3(1118.02, 228.269, -50.8409),
    vector3(1129.64, 251.203, -52.0409),
    vector3(1130.57, 251.085, -52.0409),
    vector3(1131.44, 250.73, -52.0409),
    vector3(1132.19, 250.159, -52.0409),
    vector3(1132.76, 249.412, -52.0409),
    vector3(1133.12, 248.533, -52.0409),
    vector3(1133.24, 247.598, -52.0409),
    vector3(1133.42, 255.572, -52.0409),
    vector3(1133.16, 257.251, -52.0409),
    vector3(1134.67, 258.021, -52.0409),
    vector3(1135.87, 256.819, -52.0409),
    vector3(1135.1, 255.303, -52.0409),
    vector3(1137.66, 251.328, -52.0409),
    vector3(1137.4, 253.008, -52.0409),
    vector3(1138.92, 253.779, -52.0409),
    vector3(1140.12, 252.574, -52.0409),
    vector3(1139.34, 251.061, -52.0409)
}

local slotMachines = {
    vector4( 1100.483, 230.4082, -50.8409, 45.0),
    vector4( 1100.939, 231.0017, -50.8409, 60.0),
    vector4( 1101.221, 231.6943, -50.8409, 75.0),
    vector4( 1101.323, 232.4321, -50.8409, 90.0),
    vector4( 1101.229, 233.1719, -50.8409, 105.0),
    vector4( 1108.938, 239.4797, -50.8409, -45.0),
    vector4( 1109.536, 239.0278, -50.8409, -30.0),
    vector4( 1110.229, 238.7428, -50.8409, -15.0),
    vector4( 1110.974, 238.642, -50.8409, 0.0),
    vector4( 1111.716, 238.7384, -50.8409, 15.0),
    vector4( 1112.407, 239.0216, -50.8409, 30.0),
    vector4( 1112.999, 239.4742, -50.8409, 45.0),
    vector4( 1120.853, 233.1621, -50.8409, -105.0),
    vector4( 1120.753, 232.4272, -50.8409, -90.0),
    vector4( 1120.853, 231.6886, -50.8409, -75.0),
    vector4( 1121.135, 230.9999, -50.8409, -60.0),
    vector4( 1121.592, 230.4106, -50.8409, -45.0),
    vector4( 1104.572, 229.4451, -50.8409, -36.0),
    vector4( 1104.302, 230.3183, -50.8409, -108.0),
    vector4( 1105.049, 230.845, -50.8409, 180.0),
    vector4( 1105.781, 230.2973, -50.8409, 108.0),
    vector4( 1105.486, 229.4322, -50.8409, 36.0),
    vector4( 1108.005, 233.9177, -50.8409, -36.0),
    vector4( 1107.735, 234.7909, -50.8409, -108.0),
    vector4( 1108.482, 235.3176, -50.8409, 180.0),
    vector4( 1109.214, 234.7699, -50.8409, 108.0),
    vector4( 1108.919, 233.9048, -50.8409, 36.0),
    vector4( 1113.64, 233.6755, -50.8409, -36.0),
    vector4( 1113.37, 234.5486, -50.8409, -108.0),
    vector4( 1114.117, 235.0753, -50.8409, 180.0),
    vector4( 1114.848, 234.5277, -50.8409, 108.0),
    vector4( 1114.554, 233.6625, -50.8409, 36.0),
    vector4( 1116.662, 228.8896, -50.8409, -36.0),
    vector4( 1116.392, 229.7628, -50.8409, -108.0),
    vector4( 1117.139, 230.2895, -50.8409, 180.0),
    vector4( 1117.871, 229.7419, -50.8409, 108.0),
    vector4( 1117.576, 228.8767, -50.8409, 36.0),
    vector4( 1129.64, 250.451, -52.0409, 180.0),
    vector4( 1130.376, 250.3577, -52.0409, 165.0),
    vector4( 1131.062, 250.0776, -52.0409, 150.0),
    vector4( 1131.655, 249.6264, -52.0409, 135.0),
    vector4( 1132.109, 249.0355, -52.0409, 120.0),
    vector4( 1132.396, 248.3382, -52.0409, 105.0),
    vector4( 1132.492, 247.5984, -52.0409, 90.0),
    vector4( 1133.952, 256.1037, -52.0409, -45.0),
    vector4( 1133.827, 256.9098, -52.0409, -117.0),
    vector4( 1134.556, 257.2778, -52.0409, 171.0),
    vector4( 1135.132, 256.699, -52.0409, 99.0),
    vector4( 1134.759, 255.9734, -52.0409, 27.0),
    vector4( 1138.195, 251.8611, -52.0409, -45.0),
    vector4( 1138.07, 252.6677, -52.0409, -117.0),
    vector4( 1138.799, 253.0363, -52.0409, 171.0),
    vector4( 1139.372, 252.4563, -52.0409, 99.0),
    vector4( 1139, 251.7306, -52.0409, 27.0)
}

local slotMachinesTypes = {
    4,
    5,
    6,
    7,
    8,
    1,
    2,
    3,
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

local machinesSlotWheelHashes = {
    nil,
    nil,
    nil,
    `vw_Prop_vw_slot_wheel_04a`,
    nil,
    nil,
    nil,
    `vw_Prop_vw_slot_wheel_08a`
}

local machinesObjectHashes = {
    `vw_prop_casino_slot_01a`,
    `vw_prop_casino_slot_02a`,
    `vw_prop_casino_slot_03a`,
    `vw_prop_casino_slot_04a`,
    `vw_prop_casino_slot_05a`,
    `vw_prop_casino_slot_06a`,
    `vw_prop_casino_slot_07a`,
    `vw_prop_casino_slot_08a`,
}

local machinesSlotReelHashes = {
    `vw_Prop_Casino_Slot_01a_reels`,
    `vw_Prop_Casino_Slot_02a_reels`,
    `vw_Prop_Casino_Slot_03a_reels`,
    `vw_Prop_Casino_Slot_04a_reels`,
    `vw_Prop_Casino_Slot_05a_reels`,
    `vw_Prop_Casino_Slot_06a_reels`,
    `vw_Prop_Casino_Slot_07a_reels`,
    `vw_Prop_Casino_Slot_08a_reels`,
}

local animDicts = {
    "anim_casino_a@amb@casino@games@slots@female",
    "anim_casino_a@amb@casino@games@slots@male"
}

local function getAnimDict(ped)
    local dict = 1
    if IsPedMale(ped) then
        dict = 2
    end
    return animDicts[dict]
end

local slotMachineInstances = {}
local running = false
local INPUT_ENTER = 23
local INPUT_CONTEXT = 51
local INPUT_CONTEXT_SECONDARY = 52

local currentState = nil
local usedSlotmachine = nil

local function streamAssets()
    exports.gl_utils:loadModels(machinesSlotReelHashes)
    exports.gl_utils:loadModels(machinesSlotWheelHashes)
    
    exports.gl_utils:loadAnimDicts(animDicts)
end

-- Player thread controls the state of the client playing slot machine
local function playerThread()
    local ped = PlayerPedId()
    
    StartAudioScene("dlc_vw_casino_slot_machines_playing")

    currentState = Slots_InsideCasino

    while running do
        Citizen.Wait(0)

        local timer = GetGameTimer()
        local coords = GetEntityCoords(ped)

        if currentState then
            currentState(ped, coords, timer)
        end
    end
end

-- Slot machine thread controls the state of the slot machines in the casino
local function slotMachineThread()
    local ped = PlayerPedId()

    for i=1,#slotMachines do
        local pos = slotMachines[i]
        local machineType = slotMachinesTypes[i]
        local seatPos = seats[i]

        -- Reel
        local reelHash = machinesSlotReelHashes[machineType]
        if reelHash ~= nil then
            local slot = SlotMachine:new(i, pos, seatPos, machineType, reelHash)
            table.insert(slotMachineInstances, i, slot)
        end
    end

    while running do
        Citizen.Wait(0)

        local timer = GetGameTimer()
        local coords = GetEntityCoords(ped)

        for _, slotMachine in pairs(slotMachineInstances) do
            slotMachine:tick(ped, coords, timer)
        end
    end
end

function Slots_InsideCasino(ped, coords, timer)
    local closestSlotMachine = nil
    local closestSlotMachineDistance = 2.0

    for _, slotMachine in pairs(slotMachineInstances) do
        slotMachine:tick(ped, coords, timer)

        local dist = #(coords - slotMachine.pos.xyz)
        if dist < closestSlotMachineDistance and not slotMachine.occupied then
            closestSlotMachineDistance = dist
            closestSlotMachine = slotMachine
        end
    end

    if closestSlotMachine then
        exports.gl_utils:drawNotification(string.format("Appuyer sur ~INPUT_ENTER~ pour jouer sur la machine ~h~%04d~h~ pour ~g~%d$~s~", closestSlotMachine.id, payTable[closestSlotMachine.type]))
    end

    local controlPressed = IsControlJustPressed(0, INPUT_ENTER)
    if controlPressed and closestSlotMachine then
        usedSlotmachine = closestSlotMachine
        usedSlotmachine.occupied = true
        TriggerServerEvent('gl_casino:sv:slots', usedSlotmachine.id, 'enter')
        currentState = Slots_WalkAndSit
    end
end

function Slots_WalkAndSit(ped, coords, timer)
    local animDict = getAnimDict(ped)
    local anim = anims[math.random(1,2)]

    local machineRot = vector3(0.0, 0.0, usedSlotmachine.pos.w)

    local animPos = GetAnimInitialOffsetPosition(animDict, anim[1], usedSlotmachine.pos.xyz, machineRot, 0.01, 2)
    local animRot = GetAnimInitialOffsetRotation(animDict, anim[1], usedSlotmachine.pos.xyz, machineRot, 0.01, 2)

    Citizen.Await(exports.gl_utils:followNavMesh(ped, animPos, animRot.z))

    TriggerServerEvent('capture:startTrace')
    Citizen.Wait(0)
    print(animDict, anim[1])
    Citizen.Await(exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim[1], usedSlotmachine.pos.xyz, machineRot, anim[2], anim[3], 2.0, -1.5, 13, 16, 2.0))
    Citizen.Wait(0)
    TriggerServerEvent('capture:stopTrace')

    currentState = Slots_Idle
end

local slotControls = {
    { control = INPUT_ENTER, name = "Arrêter de jouer"},
    { control = INPUT_CONTEXT, name = "Jouer !"}
}


function startIdleAnimLoop(ped)
    local animDict = getAnimDict(ped)
    local anim = anims[math.random(5,9)]

    if not usedSlotmachine then
        return nil
    end

    local machineRot = vector3(0.0, 0.0, usedSlotmachine.pos.w)
    local p = exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim[1], usedSlotmachine.pos.xyz, machineRot, anim[2], anim[3], 2.0, -1.5, 13, 16, 1000.0)

    p:next(function (v)
        if currentState ~= Slots_Idle then
            IdleAnimPromise = nil
            return
        end

        IdleAnimPromise = startIdleAnimLoop(ped)
    end)

    return p
end

local IdleAnimPromise = nil
function Slots_Idle(ped, coords, timer)
    if not IdleAnimPromise then
        IdleAnimPromise = startIdleAnimLoop(ped)
    end

    local exitPressed = IsControlJustPressed(0, INPUT_ENTER)
    if exitPressed then
        TriggerServerEvent('gl_casino:sv:slots', usedSlotmachine.id, 'leave')
        currentState = Slots_AnimExit
        return
    end

    local playPressed = IsControlJustPressed(0, INPUT_CONTEXT)
    if playPressed then
        currentState = Slots_Play
        return
    end

    exports.gl_utils:drawInstructionalButtons(slotControls)
end

function Slots_Play(ped, coords, timer)
    local animDict = getAnimDict(ped)
    local anim = anims[math.random(15,16)]

    local objectHash = machinesObjectHashes[usedSlotmachine.type]
    local objectAnim = anim[1] .. "_SLOTMACHINE"

    TriggerServerEvent('gl_casino:sv:slots', usedSlotmachine.id, 'play')

    local machineRot = vector3(0.0, 0.0, usedSlotmachine.pos.w)
    Citizen.Await(exports.gl_utils:playNetworkSynchronizedSceneWithObject(ped, objectHash, objectAnim, animDict, anim[1], usedSlotmachine.pos.xyz, machineRot, anim[2], anim[3], 2.0, -1.5, 13, 16, 1000.0))

    anim = anims[math.random(21, 23)]
    --Citizen.Await(exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim[1], usedSlotmachine.pos.xyz, machineRot, anim[2], anim[3], 2.0, -1.5, 13, 16, 1000.0))
    exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim[1], usedSlotmachine.pos.xyz, machineRot, anim[2], anim[3], 2.0, -1.5, 13, 16, 1000.0)

    currentState = Slots_WaitStopSpinning
end

function Slots_WaitStopSpinning(ped, coords, timer)
    if usedSlotmachine.spinning then
        return
    end

    currentState = Slots_Idle
    --currentState = Slots_Play
end

function Slots_AnimExit(ped, coords, timer)
    local animDict = getAnimDict(ped)
    local anim = anims[math.random(31,32)]

    local machineRot = vector3(0.0, 0.0, usedSlotmachine.pos.w)
    Citizen.Await(exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim[1], usedSlotmachine.pos.xyz, machineRot, anim[2], anim[3], 2.0, -1.5, 13, 16, 1000.0))

    ClearPedTasksImmediately(ped)

    usedSlotmachine.occupied = false
    usedSlotmachine = nil

    currentState = Slots_InsideCasino
end

function startSlotMachines()
    if running then
        return
    end

    running = true

    streamAssets()
    Citizen.CreateThread(playerThread)
    Citizen.CreateThread(slotMachineThread)
end

function stopSlotMachines()
    if not running then
        return
    end

    running = false

    for _, slotMachine in pairs(slotMachineInstances) do
        slotMachine:destroyObjects()
    end
end

anims = {
    { "enter_left", true, false },       -- 1 
    { "enter_right", true, false },      -- 2
    { "enter_left_short", true, false }, -- 3
    { "enter_right_short", true, false },-- 4
    { "base_idle_a", true, false },      -- 5
    { "base_idle_b", true, false },      -- 6
    { "base_idle_c", true, false },      -- 7
    { "base_idle_d", true, false },      -- 8
    { "base_idle_e", true, false },      -- 9
    { "press_betone_a", true, false },   -- 10
    { "press_betmax_a", true, false },   -- 11
    { "press_autospin", true, false },   -- 12
    { "press_spin_a", true, false },     -- 13
    { "press_spin_b", true, false },     -- 14
    { "pull_spin_a", true, false },      -- 15
    { "pull_spin_b", true, false },      -- 16
    { "betidle_idle_a", true, false },   -- 17
    { "betidle_idle_b", true, false },   -- 18
    { "betidle_idle_c", true, false },   -- 19
    { "betidle_press_autospin", true, false }, -- 20
    { "spinning_a", false, true },       -- 21
    { "spinning_b", false, true },       -- 22
    { "spinning_c", false, true },       -- 23
    { "win_a", true, false },            -- 24
    { "win_b", true, false },            -- 25
    { "win_c", true, false },            -- 26
    { "win_d", true, false },            -- 27
    { "betidle_to_base_transition", true, false }, -- 28
    { "win_to_spinning_wheel", true, false }, -- 29
    { "spinning_wheel", false, true },   -- 30
    { "exit_left", false, false },        -- 31
    { "exit_right", false, false },       -- 32
    { "betidle_right", false, false },    -- 33
    { "betidle_left", false, false },      -- 34
}

RegisterCommand('slotAnim', function(source, args, rawCommand)
    local num = tonumber(args[1])

    local ped = PlayerPedId()

    if num > #anims then
        return
    end

    local animDict = getAnimDict(ped)

    ClearPedTasksImmediately(ped)
    TaskPlayAnim(ped, animDict, anims[num][1], 8.0, 8.0, -1, 0, 0.0, 0, 0, 0)

end, false)



soundsRef = {
    "dlc_vw_casino_slot_machine_ak_player_sounds",
    "dlc_vw_casino_slot_machine_ir_player_sounds",
    "dlc_vw_casino_slot_machine_rsr_player_sounds",
    "dlc_vw_casino_slot_machine_fs_player_sounds",
    "dlc_vw_casino_slot_machine_ds_player_sounds",
    "dlc_vw_casino_slot_machine_kd_player_sounds",
    "dlc_vw_casino_slot_machine_td_player_sounds",
    "dlc_vw_casino_slot_machine_hz_player_sounds"
}

sounds = {
    "no_win",               -- 1
    "small_win",            -- 2
    "big_win",              -- 3
    "jackpot",              -- 4
    "place_bet",            -- 5
    "place_max_bet",        -- 6
    "spinning",             -- 7
    "start_spin",           -- 8
    "wheel_stop_clunk",     -- 9
    "wheel_stop_on_prize",  -- 10
    "welcome_stinger",      -- 11
    "spin_wheel",           -- 12
    "spin_wheel_win",       -- 13
    "attract_loop"          -- 14
}

RegisterCommand('slotSound', function(source, args, rawCommand)
    local ref = tonumber(args[1])
    local num = tonumber(args[2])

    local ped = PlayerPedId()

    if ref > #soundsRef then
        return
    end

    if num > #sounds then
        return
    end

    PlaySoundFromEntity(-1, sounds[num], ped, soundsRef[ref], false, 0)
end, false)


RegisterCommand('reelIndex', function(source, args, rawCommand)
    local idx = tonumber(args[1])

    if idx > 15 then
        return
    end

    reelIndex = idx
end, false)


local function slotsReset()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    currentState = Slots_InsideCasino
end

local function slotsSetOccupied(id, occupied)
    if id > #slotMachineInstances or id < 1 then
        return
    end
    local slotMachine = slotMachineInstances[id]
    slotMachine.occupied = occupied
end

local function slotsStartSpinning(id)
    if id > #slotMachineInstances or id < 1 then
        return
    end
    local slotMachine = slotMachineInstances[id]
    slotMachine:startSpinning()
end

local function slotsStopSpinning(id, reel1, reel2, reel3, won, amount)
    if id > #slotMachineInstances or id < 1 then
        return
    end
    local slotMachine = slotMachineInstances[id]
    slotMachine:stopSpinning(reel1, reel2, reel3, function ()
        if not usedSlotmachine then
            return
        end

        if usedSlotmachine.id ~= id then
            return
        end
        
        if won then
            exports.gl_utils:addFeedNotification('Bravo ! Tu as gagné ~g~'..amount..'$~s~', 210, false)
        else
            exports.gl_utils:addFeedNotification('Perdu ! Plus de chance la prochaine fois', 6, false)
        end
    end)
end

RegisterNetEvent('gl_casino:cl:slots', function (id, event, arg1, arg2, arg3, arg4, arg5)
    if event == 'startSpinning' then
        slotsStartSpinning(id)
    elseif event == 'stopSpinning' then
        slotsStopSpinning(id, arg1, arg2, arg3, arg4, arg5)
    elseif event == 'setOccupied' then
        slotsSetOccupied(id, arg1)
    elseif event == 'reset' then
        slotsReset()
    end
end)