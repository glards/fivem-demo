
local sharedAnimDict = 'anim_casino_b@amb@casino@games@shared@player@'
local playerAnimDict = 'anim_casino_b@amb@casino@games@blackjack@player'

local dealerSharedDict = 'anim_casino_b@amb@casino@games@shared@dealer@'
local dealerAnimDict = 'anim_casino_b@amb@casino@games@blackjack@dealer'

local dealerAnim = {
    'idle',
    'female_idle'
}

local cardValue = {
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    10,
    10,
    10
}

local cards = {
    -- Club : 1 - 13
    `vw_prop_vw_club_char_a_a`,
    `vw_prop_vw_club_char_02a`,
    `vw_prop_vw_club_char_03a`,
    `vw_prop_vw_club_char_04a`,
    `vw_prop_vw_club_char_05a`,
    `vw_prop_vw_club_char_06a`,
    `vw_prop_vw_club_char_07a`,
    `vw_prop_vw_club_char_08a`,
    `vw_prop_vw_club_char_09a`,
    `vw_prop_vw_club_char_10a`,
    `vw_prop_vw_club_char_j_a`,
    `vw_prop_vw_club_char_q_a`,
    `vw_prop_vw_club_char_k_a`,

    -- Diamond : 14 - 26
    `vw_prop_vw_dia_char_a_a`,
    `vw_prop_vw_dia_char_02a`,
    `vw_prop_vw_dia_char_03a`,
    `vw_prop_vw_dia_char_04a`,
    `vw_prop_vw_dia_char_05a`,
    `vw_prop_vw_dia_char_06a`,
    `vw_prop_vw_dia_char_07a`,
    `vw_prop_vw_dia_char_08a`,
    `vw_prop_vw_dia_char_09a`,
    `vw_prop_vw_dia_char_10a`,
    `vw_prop_vw_dia_char_j_a`,
    `vw_prop_vw_dia_char_q_a`,
    `vw_prop_vw_dia_char_k_a`,

    -- Heart : 27 - 39
    `vw_prop_vw_hrt_char_a_a`,
    `vw_prop_vw_hrt_char_02a`,
    `vw_prop_vw_hrt_char_03a`,
    `vw_prop_vw_hrt_char_04a`,
    `vw_prop_vw_hrt_char_05a`,
    `vw_prop_vw_hrt_char_06a`,
    `vw_prop_vw_hrt_char_07a`,
    `vw_prop_vw_hrt_char_08a`,
    `vw_prop_vw_hrt_char_09a`,
    `vw_prop_vw_hrt_char_10a`,
    `vw_prop_vw_hrt_char_j_a`,
    `vw_prop_vw_hrt_char_q_a`,
    `vw_prop_vw_hrt_char_k_a`,

    -- Spade : 40 - 52
    `vw_prop_vw_spd_char_a_a`,
    `vw_prop_vw_spd_char_02a`,
    `vw_prop_vw_spd_char_03a`,
    `vw_prop_vw_spd_char_04a`,
    `vw_prop_vw_spd_char_05a`,
    `vw_prop_vw_spd_char_06a`,
    `vw_prop_vw_spd_char_07a`,
    `vw_prop_vw_spd_char_08a`,
    `vw_prop_vw_spd_char_09a`,
    `vw_prop_vw_spd_char_10a`,
    `vw_prop_vw_spd_char_j_a`,
    `vw_prop_vw_spd_char_q_a`,
    `vw_prop_vw_spd_char_k_a`
}

local dealerCardOffset = {
    vector4(0.0356, 0.2105, 0.94885, 178.92),
    vector4(-0.0436, 0.21205, 0.948875, -180.0),
    vector4(-0.0636, 0.213825, 0.9496, -178.92),
    vector4(-0.0806, 0.2137, 0.950225, -177.12),
    vector4(-0.1006, 0.21125, 0.950875, 180.0),
    vector4(-0.1256, 0.21505, 0.951875, 178.56),
    vector4(-0.1416, 0.21305, 0.953, 180.0),
    vector4(-0.1656, 0.21205, 0.954025, 178.2),
    vector4(-0.1836, 0.21255, 0.95495, -177.12),
    vector4(-0.2076, 0.21105, 0.956025, 180.0),
    vector4(-0.2246, 0.21305, 0.957, 178.56)
}

local cardsOffset = {
    [1] = {
        vector4(0.5737, 0.2376, 0.948025, 69.12),
        vector4(0.562975, 0.2523, 0.94875, 67.8),
        vector4(0.553875, 0.266325, 0.94955, 66.6),
        vector4(0.5459, 0.282075, 0.9501, 70.44),
        vector4(0.536125, 0.29645, 0.95085, 70.84),
        vector4(0.524975, 0.30975, 0.9516, 67.88),
        vector4(0.515775, 0.325325, 0.95235, 69.56)
    },
    [2] = {
        vector4(0.2325, -0.1082, 0.94805, 22.11),
        vector4(0.23645, -0.0918, 0.949, 22.32),
        vector4(0.2401, -0.074475, 0.950225, 20.8),
        vector4(0.244625, -0.057675, 0.951125, 19.8),
        vector4(0.249675, -0.041475, 0.95205, 19.44),
        vector4(0.257575, -0.0256, 0.9532, 26.28),
        vector4(0.2601, -0.008175, 0.954375, 22.68)
    },
    [3] = {
        vector4(-0.2359, -0.1091, 0.9483, -21.43),
        vector4(-0.221025, -0.100675, 0.949, -20.16),
        vector4(-0.20625, -0.092875, 0.949725, -16.92),
        vector4(-0.193225, -0.07985, 0.950325, -23.4),
        vector4(-0.1776, -0.072, 0.951025, -21.24),
        vector4(-0.165, -0.060025, 0.951825, -23.76),
        vector4(-0.14895, -0.05155, 0.95255, -19.44)
    },
    [4] = {
        vector4(-0.5765, 0.2229, 0.9482, -67.03),
        vector4(-0.558925, 0.2197, 0.949175, -69.12),
        vector4(-0.5425, 0.213025, 0.9499, -64.44),
        vector4(-0.525925, 0.21105, 0.95095, -67.68),
        vector4(-0.509475, 0.20535, 0.9519, -63.72),
        vector4(-0.491775, 0.204075, 0.952825, -68.4),
        vector4(-0.4752, 0.197525, 0.9543, -64.44)
    },
}

local tablesData = {
    [1] = {
        modelHash = `vw_prop_casino_blckjack_01`,
        pos = vector4(1148.837, 269.747, -52.8409, -134.69),
        seats = {
            -- vector3(1148.367, 269.0835, -51.7879),
            -- vector3(1148.345, 269.7643, -51.7876),
            -- vector3(1148.821, 270.2321, -51.7708),
            -- vector3(1149.495, 270.2401, -51.7632)
            vector4(1149.651, 270.502, -52.84095, 245.3094),
            vector4(1148.708, 270.5051, -52.84095, 295.3094),
            vector4(1148.075, 269.8671, -52.84095, 335.3093),
            vector4(1148.08, 268.9354, -52.84095, 25.30935)
        }
    },
    [2] = {
        modelHash = `vw_prop_casino_blckjack_01`,
        pos = vector4(1151.84, 266.747, -52.8409, 45.31),
        seats = {
            -- vector3(1152.317, 267.4195, -51.8003),
            -- vector3(1152.337, 266.7202, -51.7913),
            -- vector3(1151.849, 266.2183, -51.7916),
            -- vector3(1151.182, 266.2501, -51.7864)
            vector4(1151.026, 265.9921, -52.84095, 65.30935),
            vector4(1151.969, 265.9889, -52.84095, 115.3094),
            vector4(1152.602, 266.6269, -52.84095, 155.3093),
            vector4(1152.597, 267.5587, -52.84095, 205.3094)
        },
    },
    [3] = {
        modelHash = `vw_prop_casino_blckjack_01b`,
        pos = vector4(1129.406, 262.3578, -52.041, 135.31),
        seats = {
            -- vector3(1128.713, 262.8658, -51.0035),
            -- vector3(1129.446, 262.8649, -51.0121),
            -- vector3(1129.932, 262.3822, -51.0027),
            -- vector3(1129.899, 261.6921, -51.0422)
            vector4(1130.161, 261.5438, -52.041, 155.3094),
            vector4(1130.165, 262.4864, -52.041, 205.3095),
            vector4(1129.527, 263.1194, -52.041, 245.3094),
            vector4(1128.595, 263.1143, -52.041, 295.3094)
        },
    },
    [4] = {
        modelHash = `vw_prop_casino_blckjack_01b`,
        pos = vector4(1144.429, 247.3352, -52.041, 135.31),
        seats = {
            -- vector3(1143.738, 247.8562, -51.034),
            -- vector3(1144.459, 247.8673, -51.0229),
            -- vector3(1144.951, 247.3612, -51.015),
            -- vector3(1144.913, 246.663, -51.0236)
            vector4(1145.184, 246.5213, -52.041, 155.3094),
            vector4(1145.187, 247.4638, -52.041, 205.3095),
            vector4(1144.549, 248.0968, -52.041, 245.3094),
            vector4(1143.617, 248.0918, -52.041, 295.3094)
        },
    },
}

local running = false
local INPUT_ENTER = 23

local tables = {}

local function createTables()
    tables = {}
    for k,v in ipairs(tablesData) do
        local bj = BlackjackTable:New(k, v)
        table.insert(tables, bj)
    end
end

local blackjackDealers = {}

local function createDealers()
    blackjackDealers = {}
    for k,v in ipairs(tablesData) do
        local pos = v.pos.xyz
        local heading = v.pos.w
        local genre = 1

        -- local obj = GetClosestObjectOfType(pos, 1.0, v.modelHash, false, false, false)
        -- if DoesEntityExist(obj) and DoesEntityHaveDrawable(obj) then
        --     print("Found table object !")

        --     local bones = {
        --         GetEntityBoneIndexByName(obj, 'Chair_Base_01'),
        --         GetEntityBoneIndexByName(obj, 'Chair_Base_02'),
        --         GetEntityBoneIndexByName(obj, 'Chair_Base_03'),
        --         GetEntityBoneIndexByName(obj, 'Chair_Base_04'),
        --     }

        --     for k,v in ipairs(bones) do
        --         if v == -1 then
        --             print("Bones not found ".. k)
        --         else
        --             local seatPos = GetWorldPositionOfEntityBone(obj, v)
        --             local seatRot = GetEntityBoneRotation(obj, v)

        --             local rot = seatRot.z
        --             if rot < 0.0 then
        --                 rot = rot + 360.0
        --             end
        --             local seatVector = vector4(seatPos.xyz, rot)
        --             print("Seat ".. k .. " : ".. seatVector)
        --         end
        --     end
        -- else
        --     print("Object not found")
        -- end

        -- Coordinate from decompiled script put peds in the table so we rotate it
        heading = heading-180.0
        if heading < 0.0 then
            heading = heading + 360.0
        end
        --  and move it a bit backward
        local rad = math.rad(heading)
        local backward = vector3(-math.sin(rad), math.cos(rad), 0.0)
        pos = pos - 0.85*backward
      
        local ped = CreateDealerPed(pos, heading, genre)

        table.insert(blackjackDealers, ped)

        local anim = dealerAnim[genre]

        exports.gl_utils:playNetworkSynchronizedScene(ped, dealerSharedDict, anim, pos, vector3(0.0,0.0,heading), false, true, 2.0, -2.0, 13, 16, 1000.0)

        -- Dealer cards
        do
            local offset = dealerCardOffset[1]
            local card = cards[math.random(1, #cards)]
            local cardPos = GetObjectOffsetFromCoords(v.pos.xyz, v.pos.w, offset.xyz)
            local cardEntity = CreateObjectNoOffset(card, cardPos, false, false, true)
            SetEntityRotation(cardEntity, vector3(0.0, 0.0, v.pos.w) + vector3(0.0, 0.0, offset.w), 2, true)
        end
        do
            local offset = dealerCardOffset[2]
            local card = cards[math.random(1, #cards)]
            local cardPos = GetObjectOffsetFromCoords(v.pos.xyz, v.pos.w, offset.xyz)
            local cardEntity = CreateObjectNoOffset(card, cardPos, false, false, true)
            SetEntityRotation(cardEntity, vector3(0.0, 0.0, v.pos.w) + vector3(0.0, 0.0, offset.w), 2, true)
        end

        -- Cards on table
        for _, cardOffset in pairs(cardsOffset) do
            for _, offset in pairs(cardOffset) do
                local card = cards[math.random(1, #cards)]
                local cardPos = GetObjectOffsetFromCoords(v.pos.xyz, v.pos.w, offset.xyz)
                local cardEntity = CreateObjectNoOffset(card, cardPos, false, false, true)
                SetEntityRotation(cardEntity, vector3(0.0, 0.0, v.pos.w) + vector3(0.0, 0.0, offset.w), 2, true)
            end
        end
    end
end

local function loadingThread()
    print('Loading blackjack')
    exports.gl_utils:loadAnimDicts(sharedAnimDict)
    exports.gl_utils:loadAnimDicts(playerAnimDict)
    exports.gl_utils:loadAnimDicts(dealerSharedDict)
    exports.gl_utils:loadAnimDicts(dealerAnimDict)

    createDealers()
    createTables()
end

local currentState = nil

local function playerThread()
    local ped = PlayerPedId()

    currentState = Blackjack_InsideCasino

    while running do
        Citizen.Wait(0)

        local timer = GetGameTimer()
        local coords = GetEntityCoords(ped)

        if currentState then
            currentState(ped, coords, timer)
        end
    end
end

function startBlackjack()
    running = true
    Citizen.CreateThread(loadingThread)
    Citizen.CreateThread(playerThread)
end

function stopBlackjack()
    print('Clearing blackjack peds and objects')
    running = false
    for k,v in ipairs(blackjackDealers) do
        DeleteEntity(v)
    end
    blackjackDealers = {}
end

local usedBlackjackTable = nil
local seatIndex = nil

function Blackjack_InsideCasino(ped, coords, timer)
    local closestTable = nil
    local closestTableDistance = 3.0
    for _, bj in ipairs(tables) do
        local dist = #(coords - bj.pos.xyz)

        if dist < closestTableDistance then
            closestTableDistance = dist
            closestTable = bj
        end
        -- for seatId, seat in pairs(bj.seats) do
        -- end
    end

    if closestTable then
        exports.gl_utils:drawNotification(string.format("Appuyez sur ~INPUT_ENTER~ pour jouer sur la table de blackjack numéro %d", closestTable.id))
    end

    local controlPressed = IsControlJustPressed(0, INPUT_ENTER)
    if controlPressed and closestTable then
        usedBlackjackTable = closestTable

        local closestSeatDistance = 3.0
        local closestSeatIdx = nil
        for idx, seatPos in ipairs(usedBlackjackTable.seats) do
            local dist = #(coords - seatPos.xyz)
            if dist < closestSeatDistance then
                closestSeatIdx = idx
                closestSeatDistance = dist
            end
        end

        if closestSeatIdx then
            seatIndex = closestSeatIdx
            currentState = Blackjack_WalkAndSit
        end
    end
end


function Blackjack_WalkAndSit(ped, coords, timer)
    local sitAnim = {
        'sit_enter_left',
        'sit_enter_left_side',
        'sit_enter_right_side'
    }

    local animDict = sharedAnimDict
    local anim = sitAnim[math.random(1,3)]

    local seatPos = usedBlackjackTable.seats[seatIndex]
    local seatRot = vector3(0.0, 0.0, seatPos.w)
    
    local animPos = GetAnimInitialOffsetPosition(animDict, anim, seatPos.xyz, seatRot, 0.01, 2)
    local animRot = GetAnimInitialOffsetRotation(animDict, anim, seatPos.xyz, seatRot, 0.01, 2)
    
    Citizen.Await(exports.gl_utils:followNavMesh(ped, animPos, animRot.z))

    Citizen.Await(exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim, seatPos.xyz, seatRot, true, false, 2.0, -1.5, 13, 16, 2.0))
    
    currentState = Blackjack_Idle
end

function Blackjack_Idle(ped, coords, timer)
    
    local bjControls = {
        { control = INPUT_ENTER, name = "Arrêter de jouer"},
    }

    local exitPressed = IsControlJustPressed(0, INPUT_ENTER)
    if exitPressed then
        currentState = Blackjack_Exit
        return
    end
    
    exports.gl_utils:drawInstructionalButtons(bjControls)
end


function Blackjack_Exit(ped, coords, timer)
    local exitAnim = 'sit_exit_left'

    local animDict = sharedAnimDict
    local anim = exitAnim

    local seatPos = usedBlackjackTable.seats[seatIndex]
    local seatRot = vector3(0.0, 0.0, seatPos.w)
    
    Citizen.Await(exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim, seatPos.xyz, seatRot, false, false, 2.0, -1.5, 13, 16, 2.0))

    ClearPedTasksImmediately(ped)
    
    usedBlackjackTable = nil
    seatIndex = nil

    currentState = Blackjack_InsideCasino
end