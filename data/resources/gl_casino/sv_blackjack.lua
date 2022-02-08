local tables = {}

local STATES = {
    WAITING_PLAYER = 1,
    BET_ROUND = 2,
    DEAL_CARDS = 3,
    PLAYER_ROUND = 4,
    DEALER_ROUND = 5,
}

local ROUND = {
    WAIT = 1,
    BET = 2,
    SKIP = 3,
    DONE = 4,
}

local BET_ROUND_TIMEOUT = 25000
local PLAYER_ROUND_TIMEOUT = 15000

for i=1,4 do
    tables[i] = {
        id = i,
        state = STATES.WAITING_PLAYER,
        deck = {},
        dealerCards = {},
        seats = {
            { occupied = false, ped = nil, cards = {} },
            { occupied = false, ped = nil, cards = {} },
            { occupied = false, ped = nil, cards = {} },
            { occupied = false, ped = nil, cards = {} },
        }
    }
end

local function hasPlayers(t)
    for k,v in pairs(t.seats) do
        if v.occupied then
            return true
        end
    end

    return false
end

local function resetTable(t)
    t.deck = {}
    t.dealerCards = {}
    t.betRoundStart = nil
    
    for k,v in pairs(t.seats) do
        v.cards = {}
        v.roundState = ROUND.WAIT
        v.participantPed = nil
    end
end

-- Game loop :
-- 1. (betRoundTick) A player sits at the table, dealer waits a 15 seconds for other players to join. Players choose to join the round (bet X$) or skip the round. Once everyone has bet or a timer has elapsed (25 seconds)
-- 2. (dealCardsTick) The dealers gives one card hidden to itself and then one card visible to all players. Then one card visible to itself and then one card visible to all players.
-- 3. (playerRoundTick) Turn for all players : choose to get a card or stand. Repeat until the player stands or is busted (> 21). Timeout for player choice (15s).
-- 4. (dealerRoundTick) Turn for the dealer : check the hidden card then while it has less than 17 or is busted, it gets a card.
-- 5. If the player wins it gets a 3/2 payout

local function waitingPlayerTick(t)
    if hasPlayers(t) then
        resetTable(t)
        t.state = STATES.BET_ROUND
        t.betRoundStart = GetGameTimer()
    end
end

local function betRoundTick(t)
    local playerCount = 0
    local playerRoundDone = 0

    -- Check the player that have changed their round state
    for k,v in pairs(t.seats) do
        if v.occupied then
            playerCount = playerCount + 1

            if v.roundState ~= ROUND.WAIT then
                playerRoundDone = playerRoundDone + 1
            end
        end
    end

    -- All player have chosen their round
    if playerCount == playerRoundDone then
        t.state = STATES.DEAL_CARDS
        return
    end

    -- Timeout for the selection
    local currentTimestamp = GetGameTimer()
    if (currentTimestamp - t.betRoundStart) > BET_ROUND_TIMEOUT then
        t.state = STATES.DEAL_CARDS
        return
    end
end

local function dealCardsTick(t)

    local drawnCards = 0

    local dealResult = {}

    -- One card each, first dealer and then the players
    local card = drawCard(t.deck)
    table.insert(t.dealerCards, card)
    table.insert(dealResult, { seatId = 0, card = card})
    drawnCards = drawnCards + 1
    print(string.format("Draw card #1 %s for table %d dealer", cardName(card), t.id))

    for k,v in pairs(t.seats) do
        if v.occupied then
            card = drawCard(t.deck)
            table.insert(v.cards, card)
            table.insert(dealResult, { seatId = k, card = card})
            print(string.format("Draw card #1 %s for table %d and seat %d", cardName(card), t.id, k))
            drawnCards = drawnCards + 1
        end
    end

    -- Second card each, first dealer and then the players
    card = drawCard(t.deck)
    table.insert(t.dealerCards, card)
    table.insert(dealResult, { seatId = 0, card = card})
    drawnCards = drawnCards + 1
    print(string.format("Draw card #2 %s for table %d dealer", cardName(card), t.id))

    for k,v in pairs(t.seats) do
        if v.occupied then
            card = drawCard(t.deck)
            table.insert(v.cards, card)
            table.insert(dealResult, { seatId = k, card = card})
            print(string.format("Draw card #2 %s for table %d and seat %d", cardName(card), t.id, k))
            drawnCards = drawnCards + 1
        end
    end

    -- Send the information to the clients inside the casino
    BroadcastCasinoEvent("gl_casino:bj:dealCards", t.id, dealResult)

    -- Wait for the animation to be executed
    Citizen.Wait(drawnCards * 3500)
    t.state = STATES.WAITING_PLAYER
end

local function playerRoundTick(t)
    -- Tell all the players to start playing
    local startTime = GetGameTimer()
    for k,v in pairs(t.seats) do
        if v.roundState == ROUND.BET then
            v.lastActionTime = startTime
            TriggerClientEvent("gl_casino:bj:playerRound", v.participantPed, true)
        else 
            TriggerClientEvent("gl_casino:bj:playerRound", v.participantPed, false)
        end
    end

    -- Now wait until all player have finished their round
    local roundActive = true
    repeat
        Citizen.Wait(0)

        local currentTime = GetGameTimer()
        local finished = true
        for k,v in pairs(t.seats) do
            if v.roundState == ROUND.BET then
                finished = false

                if (currentTime - v.lastActionTime) > PLAYER_ROUND_TIMEOUT then
                    finished = true
                    TriggerClientEvent("gl_casino:bj:playerRound", v.participantPed, false)
                    v.roundState = ROUND.DONE
                end
            end
        end

        if finished then
            roundActive = false
        end
    until not roundActive

    t.state = STATES.DEALER_ROUND
end

local function dealerRoundTick(t)
    -- Dealer check his card

    -- Dealer stand on 17 or more, so draw cards until we hit at least 17 or bust
end

local function tableTick(t)
    if t.state == STATES.WAITING_PLAYER then
        waitingPlayerTick(t)
    elseif t.state == STATES.BET_ROUND then
        betRoundTick(t)
    elseif t.state == STATES.DEAL_CARDS then
        dealCardsTick(t)
    elseif t.state == STATES.PLAYER_ROUND then
        playerRoundTick(t)
    elseif t.state == STATES.DEALER_ROUND then
        dealerRoundTick(t)
    end
end

local running = false
local function blackjackLoop(tableId)
    while running do
        Citizen.Wait(1000)
        
        local t = tables[tableId]
        if t then
            tableTick(t)
        end
    end
end

for i=1,4 do
    Citizen.CreateThread(function ()
        blackjackLoop(i)
    end)
end

function startBlackjack()
    running = true
    Citizen.CreateThread(blackjackLoop)
end

function stopBlackjack()
    running = false
end

local function playerSitAtTable(tableId, seatId)
    local src = source

    local t = tables[tableId]
    if t == nil then
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    local seat = t.seats[seatId]
    if seat == nil then
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    if seat.occupied then
        print(string.format("Player %d tried to use seat %d at table %d which is occupied by player %d", src, seatId, tableId, seat.ped))
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    print(string.format("Player %d sat at table %d on seat %d", src, tableId, seatId))

    seat.occupied = true
    seat.ped = src

    BroadcastCasinoEvent("gl_casino:bj:tableSeatOccupied", tableId, seatId)
end
RegisterNetEvent("gl_casino:bj:playerSitAtTable", playerSitAtTable)

local function playerLeaveTable(tableId, seatId)
    local src = source

    local t = tables[tableId]
    if t == nil then
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    local seat = t.seats[seatId]
    if seat == nil then
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    if seat.ped ~= src then
        print(string.format("Player %d tried to free seat %d at table %d which is occupied by player %d", src, seatId, tableId, seat.ped))
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    print(string.format("Player %d left table %d from seat %d", src, tableId, seatId))

    seat.occupied = false
    seat.ped = nil

    BroadcastCasinoEvent("gl_casino:bj:tableSeatFreed", tableId, seatId)
end
RegisterNetEvent("gl_casino:bj:playerLeaveTable", playerLeaveTable)

local function playerBetRound(tableId, seatId)
    local src = source

    local t = tables[tableId]
    if t == nil then
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    local seat = t.seats[seatId]
    if seat == nil then
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    if seat.ped ~= src then
        print(string.format("Player %d tried to use seat %d at table %d which is occupied by player %d", src, seatId, tableId, seat.ped))
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    seat.roundState = ROUND.BET
    seat.participantPed = src
end
RegisterNetEvent("gl_casino:bj:playerBetRound", playerBetRound)

local function playerSkipRound(tableId, seatId)
    local src = source

    local t = tables[tableId]
    if t == nil then
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    local seat = t.seats[seatId]
    if seat == nil then
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    if seat.ped ~= src then
        print(string.format("Player %d tried to use seat %d at table %d which is occupied by player %d", src, seatId, tableId, seat.ped))
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    seat.roundState = ROUND.SKIP
    seat.participantPed = src
end
RegisterNetEvent("gl_casino:bj:playerSkipRound", playerSkipRound)
