
local sharedAnimDict = 'anim_casino_b@amb@casino@games@shared@player@'
local playerAnimDict = 'anim_casino_b@amb@casino@games@blackjack@player'

local dealerSharedDict = 'anim_casino_b@amb@casino@games@shared@dealer@'
local dealerAnimDict = 'anim_casino_b@amb@casino@games@blackjack@dealer'


local tableBets = {
    600,
    600,
    1500,
    1500
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
            vector4(1148.08, 268.9354, -52.84095, 25.30935),
            vector4(1148.075, 269.8671, -52.84095, 335.3093),
            vector4(1148.708, 270.5051, -52.84095, 295.3094),
            vector4(1149.651, 270.502, -52.84095, 245.3094),
        },
        bet = tableBets[1]
    },
    [2] = {
        modelHash = `vw_prop_casino_blckjack_01`,
        pos = vector4(1151.84, 266.747, -52.8409, 45.31),
        seats = {
            -- vector3(1152.317, 267.4195, -51.8003),
            -- vector3(1152.337, 266.7202, -51.7913),
            -- vector3(1151.849, 266.2183, -51.7916),
            -- vector3(1151.182, 266.2501, -51.7864)
            vector4(1152.597, 267.5587, -52.84095, 205.3094),
            vector4(1152.602, 266.6269, -52.84095, 155.3093),
            vector4(1151.969, 265.9889, -52.84095, 115.3094),
            vector4(1151.026, 265.9921, -52.84095, 65.30935),
        },
        bet = tableBets[2]
    },
    [3] = {
        modelHash = `vw_prop_casino_blckjack_01b`,
        pos = vector4(1129.406, 262.3578, -52.041, 135.31),
        seats = {
            -- vector3(1128.713, 262.8658, -51.0035),
            -- vector3(1129.446, 262.8649, -51.0121),
            -- vector3(1129.932, 262.3822, -51.0027),
            -- vector3(1129.899, 261.6921, -51.0422)
            vector4(1128.595, 263.1143, -52.041, 295.3094),
            vector4(1129.527, 263.1194, -52.041, 245.3094),
            vector4(1130.165, 262.4864, -52.041, 205.3095),
            vector4(1130.161, 261.5438, -52.041, 155.3094),
        },
        bet = tableBets[3]
    },
    [4] = {
        modelHash = `vw_prop_casino_blckjack_01b`,
        pos = vector4(1144.429, 247.3352, -52.041, 135.31),
        seats = {
            -- vector3(1143.738, 247.8562, -51.034),
            -- vector3(1144.459, 247.8673, -51.0229),
            -- vector3(1144.951, 247.3612, -51.015),
            -- vector3(1144.913, 246.663, -51.0236)
            vector4(1143.617, 248.0918, -52.041, 295.3094),
            vector4(1144.549, 248.0968, -52.041, 245.3094),
            vector4(1145.187, 247.4638, -52.041, 205.3095),
            vector4(1145.184, 246.5213, -52.041, 155.3094),
        },
        bet = tableBets[4]
    },
}

local running = false
local INPUT_ENTER = 23
local INPUT_RELOAD = 45
local INPUT_TALK = 46

local tables = {}

local function createTables()
    for k,v in pairs(tablesData) do
        local bj = BlackjackTable:New(k, v)
        tables[k] = bj
    end
end

local function loadingThread()
    exports.gl_utils:loadAnimDicts(sharedAnimDict)
    exports.gl_utils:loadAnimDicts(playerAnimDict)
    exports.gl_utils:loadAnimDicts(dealerSharedDict)
    exports.gl_utils:loadAnimDicts(dealerAnimDict)

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
    tables = {}
    Citizen.CreateThread(loadingThread)
    Citizen.CreateThread(playerThread)
end

function stopBlackjack()
    running = false

    for k,t in pairs(tables) do
        t:dispose()
    end
end

local roundStart = false
local usedBlackjackTable = nil
local seatIndex = nil
local playerRoundActive = false

function Blackjack_InsideCasino(ped, coords, timer)
    local closestTable = nil
    local closestTableDistance = 3.0
    for tableId, bj in pairs(tables) do
        local dist = #(coords - bj.pos.xyz)

        if dist < closestTableDistance and bj:hasFreeSeats() then
            closestTableDistance = dist
            closestTable = bj
        end
    end

    if closestTable then
        exports.gl_utils:drawNotification(string.format("Appuyez sur ~INPUT_ENTER~ pour jouer sur la table de blackjack numéro %d pour ~g~%d$~s~", closestTable.id, closestTable.bet))
    end

    local controlPressed = IsControlJustPressed(0, INPUT_ENTER)
    if controlPressed and closestTable then
        usedBlackjackTable = closestTable

        local closestSeatDistance = 3.0
        local closestSeatId = nil
        for seatId, seatPos in pairs(usedBlackjackTable.seats) do

            if not usedBlackjackTable.seatsOccupied[seatId] then
                local dist = #(coords - seatPos.xyz)
                if dist < closestSeatDistance then
                    closestSeatId = seatId
                    closestSeatDistance = dist
                end
            end
        end

        if closestSeatId then
            seatIndex = closestSeatId
            currentState = Blackjack_WalkAndSit
            TriggerServerEvent("gl_casino:bj:playerSitAtTable", usedBlackjackTable.id, seatIndex)
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
    
    currentState = Blackjack_WaitRoundStart
end
function Blackjack_WaitRoundStart(ped, coords, timer)
    local controls = {
        {control = INPUT_ENTER, name = "Sortir de la table"},
    }

    local exitPressed = IsControlJustPressed(0, INPUT_ENTER)
    if exitPressed then
        currentState = Blackjack_Exit
        return
    end

    if usedBlackjackTable == nil then
        return
    end

    exports.gl_utils:drawInstructionalButtons(controls)

    if roundStart then
        currentState = Blackjack_BetRound
        roundStart = false
    end
end

function Blackjack_BetRound(ped, coords, timer)
    if usedBlackjackTable == nil then
        return
    end

    local bjControls = {
        { control = INPUT_ENTER, name = "Sortir de la table"},
        { control = INPUT_TALK, name = string.format("Miser %d$", usedBlackjackTable.bet)},
        { control = INPUT_RELOAD, name = "Passer"},
    }

    local exitPressed = IsControlJustPressed(0, INPUT_ENTER)
    if exitPressed then
        currentState = Blackjack_Exit
        return
    end

    local betPressed = IsControlJustPressed(0, INPUT_TALK)
    if betPressed then
        TriggerServerEvent("gl_casino:bj:playerBetRound", usedBlackjackTable.id, seatIndex)
        playerRoundActive = false
        currentState = Blackjack_PlayerRound
        return
    end

    local skipPressed = IsControlJustPressed(0, INPUT_RELOAD)
    if skipPressed then
        TriggerServerEvent("gl_casino:bj:playerSkipRound", usedBlackjackTable.id, seatIndex)
        playerRoundActive = false
        currentState = Blackjack_PlayerRound
        return
    end

    exports.gl_utils:drawInstructionalButtons(bjControls)
end

function Blackjack_PlayerRound(ped, coords, timer)
    local controls = {
        {control = INPUT_ENTER, name = "Sortir de la table"},
    }

    if playerRoundActive then
        table.insert(controls, {control = INPUT_TALK, name = "Tirer carte"})
        table.insert(controls, {control = INPUT_RELOAD, name = "Rester"})
    end
    
    local exitPressed = IsControlJustPressed(0, INPUT_ENTER)
    if exitPressed then
        currentState = Blackjack_Exit
        return
    end

    if playerRoundActive then
        local hitCard = IsControlJustPressed(0, INPUT_TALK)
        if hitCard then
            TriggerServerEvent("gl_casino:bj:playerHitCard", usedBlackjackTable.id, seatIndex)
            playerRoundActive = false
            return
        end

        local stand = IsControlJustPressed(0, INPUT_RELOAD)
        if stand then
            TriggerServerEvent("gl_casino:bj:playerStand", usedBlackjackTable.id, seatIndex)
            playerRoundActive = false
            return
        end
    end

    exports.gl_utils:drawInstructionalButtons(controls)
end

function Blackjack_Exit(ped, coords, timer)
    TriggerServerEvent("gl_casino:bj:playerLeaveTable", usedBlackjackTable.id, seatIndex)

    local exitAnim = 'sit_exit_left'

    local animDict = sharedAnimDict
    local anim = exitAnim

    local seatPos = usedBlackjackTable.seats[seatIndex]
    local seatRot = vector3(0.0, 0.0, seatPos.w)
    
    Citizen.Await(exports.gl_utils:playNetworkSynchronizedScene(ped, animDict, anim, seatPos.xyz, seatRot, false, false, 2.0, -1.5, 13, 16, 2.0))
    
    blackjackReset()
end

function blackjackReset()
    currentState = Blackjack_InsideCasino
    
    usedBlackjackTable = nil
    seatIndex = nil

    ClearPedTasksImmediately(ped)
end
RegisterNetEvent("gl_casino:bj:reset", blackjackReset)

local function blackjackTableSeatOccupied(tableId, seatId)
    local t = tables[tableId]
    if t == nil then
        return
    end

    if t.seatsOccupied[seatId] == nil then
        return
    end

    t.seatsOccupied[seatId] = true
end
RegisterNetEvent("gl_casino:bj:tableSeatOccupied", blackjackTableSeatOccupied)

local function blackjackTableSeatFreed(tableId, seatId)
    local t = tables[tableId]
    if t == nil then
        return
    end

    if t.seatsOccupied[seatId] == nil then
        return
    end

    t.seatsOccupied[seatId] = false
end
RegisterNetEvent("gl_casino:bj:tableSeatFreed", blackjackTableSeatFreed)

local function blackjackTableRoundStart(tableId)
    if usedBlackjackTable == nil then
        return
    end

    if usedBlackjackTable.id ~= tableId then
        return
    end

    roundStart = true
end
RegisterNetEvent("gl_casino:bj:roundStart", blackjackTableRoundStart)

local function blackjackTableDealResult(tableId, dealResult)
    local t = tables[tableId]
    if t == nil then
        return
    end

    t:dealCards(dealResult)
end
RegisterNetEvent("gl_casino:bj:dealCards", blackjackTableDealResult)

local function blackjackPlayerRoundState(isActive)
    playerRoundActive = isActive
end
RegisterNetEvent("gl_casino:bj:playerRound", blackjackPlayerRoundState)

local function blackjackCheckCards(tableId)
    local t = tables[tableId]
    if t == nil then
        return
    end

    t:dealerCheckCard()
end
RegisterNetEvent("gl_casino:bj:checkCards", blackjackCheckCards)

local function blackjackRoundResult(tableId, amountWon, value, dealerValue)
    if not usedBlackjackTable then
        return
    end

    if usedBlackjackTable.id ~= tableId then
        return
    end
    if value == dealerValue then
        exports.gl_utils:addFeedNotification('Egalité ! Tu récupères ta mise de ~g~'.. amountWon ..'$~s~ avec une main à ~y~'.. value .. '~s~', 70, false)
    elseif amountWon > 0 then
        exports.gl_utils:addFeedNotification('Félicitation ! Tu as gagné ~g~'.. amountWon ..'$~s~ avec une main à ~y~'.. value .. '~s~ contre le croupier à ~y~' .. dealerValue .. '~s~', 210, false)
    else
        exports.gl_utils:addFeedNotification('Perdu ! Plus de chance la prochaine fois. Tu avais une main à ~y~'.. value .. '~s~ contre le croupier à ~y~' .. dealerValue .. '~s~', 6, false)
    end

    currentState = Blackjack_WaitRoundStart
end
RegisterNetEvent("gl_casino:bj:roundResult", blackjackRoundResult)

local function blackjackRemoveCards(tableId)
    local t = tables[tableId]
    if t == nil then
        return
    end

    t:removeCards()
end
RegisterNetEvent("gl_casino:bj:removeCards", blackjackRemoveCards)

-- Local notification
local function blackjackCardDealt(tableId, seatId, card, hand)
    if not usedBlackjackTable then
        return
    end

    if usedBlackjackTable.id ~= tableId then
        return
    end

    if seatIndex ~= seatId and seatId ~= 0 then
        return
    end

    local handValue = getBlackjackValue(hand)
    
    if seatId == 0 then
        if handValue > 21 then
            exports.gl_utils:addFeedNotification('Le croupier a reçu la carte ~h~' .. cardName(card) .. '~h~. Sa main vaut ~y~' .. handValue ..'~s~, elle dépasse 21 !', 6, false)
        elseif handValue == 21 then
            exports.gl_utils:addFeedNotification('Le croupier a reçu la carte ~h~' .. cardName(card) .. '~h~. Sa main vaut ~y~' .. handValue ..'~s~ ! Blackjack !', 140, false)
        else
            exports.gl_utils:addFeedNotification('Le croupier a reçu la carte ~h~' .. cardName(card) .. '~h~. Sa main vaut ~y~' .. handValue ..'~s~ !', 140, false)
        end
    else
        if handValue > 21 then
            exports.gl_utils:addFeedNotification('Tu as reçu la carte ~h~' .. cardName(card) .. '~h~. Ta main vaut ~y~' .. handValue ..'~s~, elle dépasse 21 !', 6, false)
        elseif handValue == 21 then
            exports.gl_utils:addFeedNotification('Tu as reçu la carte ~h~' .. cardName(card) .. '~h~. Ta main vaut ~y~' .. handValue ..'~s~ ! Blackjack !', 120, false)
        else
            exports.gl_utils:addFeedNotification('Tu as reçu la carte ~h~' .. cardName(card) .. '~h~. Ta main vaut ~y~' .. handValue ..'~s~ !', 70, false)
        end
        
    end
end
AddEventHandler("gl_casino:bj:notifCardDealt", blackjackCardDealt)