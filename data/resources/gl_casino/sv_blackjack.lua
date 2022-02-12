local tables = {}

local STATES = {
    WAITING_PLAYER = 1,
    BET_ROUND = 2,
    DEAL_CARDS = 3,
    PLAYER_ROUND = 4,
    DEALER_ROUND = 5,
}

local ROUND = {
    NEW = 1,
    WAIT = 2,
    BET = 3,
    SKIP = 4,
    DONE = 5,
}

local CARD_DELAY = 3300
local CHECK_DELAY = 4000
local REMOVE_DELAY = 3500
local BET_ROUND_TIMEOUT = 25000
local PLAYER_ROUND_TIMEOUT = 15000

local tableBets = {
    600,
    600,
    1500,
    1500
}

local function resetTable(t)
    t.deck = {}
    t.dealerCards = {}
    t.betRoundStart = nil
    t.dealStack = {}
    
    for k,v in pairs(t.seats) do
        v.cards = {}
        v.roundState = ROUND.NEW
        v.participantPed = nil
    end
end

for i=1,4 do
    tables[i] = {
        id = i,
        state = STATES.WAITING_PLAYER,
        bet = tableBets[i],
        deck = {},
        dealerCards = {},
        seats = {
            { occupied = false, ped = nil, cards = {} },
            { occupied = false, ped = nil, cards = {} },
            { occupied = false, ped = nil, cards = {} },
            { occupied = false, ped = nil, cards = {} },
        }
    }
    resetTable(tables[i])
end

local function hasPlayers(t)
    for k,v in pairs(t.seats) do
        if v.occupied then
            return true
        end
    end

    return false
end


local function getTableAndSeat(src, tableId, seatId)
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

    if seat.ped and seat.ped ~= src then
        print(string.format("Player %d tried to use seat %d at table %d which is occupied by player %d", src, seatId, tableId, seat.ped))
        TriggerClientEvent("gl_casino:bj:reset", src)
        return
    end

    return t, seat
end

-- Game loop :
-- 1. (betRoundTick) A player sits at the table, dealer waits a 15 seconds for other players to join. Players choose to join the round (bet X$) or skip the round. Once everyone has bet or a timer has elapsed (25 seconds)
-- 2. (dealCardsTick) The dealers gives one card hidden to itself and then one card visible to all players. Then one card visible to itself and then one card visible to all players.
-- 3. (playerRoundTick) Turn for all players : choose to get a card or stand. Repeat until the player stands or is busted (> 21). Timeout for player choice (15s).
-- 4. (dealerRoundTick) Turn for the dealer : check the hidden card then while it has less than 17 or is busted, it gets a card. If the player wins it gets a 3/2 payout

local function waitingPlayerTick(t)
    if hasPlayers(t) then
        print(string.format("Round start on table %d", t.id))
        t.state = STATES.BET_ROUND
        t.betRoundStart = GetGameTimer()

        for k,v in pairs(t.seats) do
            if v.occupied then
                v.round = ROUND.WAIT
                TriggerClientEvent("gl_casino:bj:roundStart", v.ped, t.id)
            end
        end
    end
end

local function betRoundTick(t)
    local playerCount = 0
    local playerRoundDone = 0

    -- Check the player that have changed their round state
    for k,v in pairs(t.seats) do
        if v.occupied then
            playerCount = playerCount + 1

            if v.roundState == ROUND.NEW then
                v.roundState = ROUND.WAIT
                TriggerClientEvent("gl_casino:bj:roundStart", v.ped, t.id)
            end

            if v.roundState ~= ROUND.WAIT then
                playerRoundDone = playerRoundDone + 1
            end
        end
    end

    -- All player have chosen their round
    if playerCount == playerRoundDone then
        print(string.format("All players have made their participation choice on table %d", t.id))
        if playerRoundDone > 0 then
            t.state = STATES.DEAL_CARDS
        else
            t.state = STATES.WAITING_PLAYER
        end
        return
    end

    -- Timeout for the selection
    local currentTimestamp = GetGameTimer()
    if (currentTimestamp - t.betRoundStart) > BET_ROUND_TIMEOUT then
        print(string.format("Timeout waiting for player participation choice on table %d (%d/%d made decisions)", t.id, playerRoundDone, playerCount))
        if playerRoundDone > 0 then
            t.state = STATES.DEAL_CARDS
        else
            t.state = STATES.WAITING_PLAYER
        end
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
        if v.roundState == ROUND.BET then
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
        if v.roundState == ROUND.BET then
            card = drawCard(t.deck)
            table.insert(v.cards, card)
            table.insert(dealResult, { seatId = k, card = card})
            print(string.format("Draw card #2 %s for table %d and seat %d", cardName(card), t.id, k))
            drawnCards = drawnCards + 1
        end
    end

    local dealerValue = getBlackjackValue(t.dealerCards)
    print(string.format("Table %d dealer has blackjack value of %d", t.id, dealerValue))

    for k,v in pairs(t.seats) do
        if v.roundState == ROUND.BET then
            local cardsValue = getBlackjackValue(v.cards)
            print(string.format("Table %d seat %d has blackjack value of %d", t.id, k, cardsValue))
        end
    end

    -- Send the information to the clients inside the casino
    BroadcastCasinoEvent("gl_casino:bj:dealCards", t.id, dealResult)

    -- Wait for the animation to be executed
    Citizen.Wait(drawnCards * CARD_DELAY)
    print(string.format("Finished dealing card on table %d, going to players rounds", t.id))
    t.state = STATES.PLAYER_ROUND
end

local function playerRoundTick(t)
    -- Tell all the players to start playing
    local startTime = GetGameTimer()
    for k,v in pairs(t.seats) do
        if v.participantPed then
            if v.roundState == ROUND.BET then
                v.lastActionTime = startTime
                TriggerClientEvent("gl_casino:bj:playerRound", v.participantPed, true)
            else
                TriggerClientEvent("gl_casino:bj:playerRound", v.participantPed, false)
            end
        end
    end

    -- Now wait until all player have finished their round
    local roundActive = true
    repeat
        Citizen.Wait(0)

        -- Check for cards to deal
        local cardsToDeal = false
        local drawnCards = 0
        local dealResult = {}
        local seatsStillPlaying = {}
        local deal = table.remove(t.dealStack)
        while deal do
            cardsToDeal = true
            table.insert(dealResult, deal)
            drawnCards = drawnCards + 1

            local seat = t.seats[deal.seatId]

            local cardsValue = getBlackjackValue(seat.cards)
            print(string.format("Table %d and seat %d has hand %d", t.id, deal.seatId, cardsValue))
            if cardsValue > 21 then
                seat.roundState = ROUND.DONE
                print(string.format("Table %d and seat %d is busted", t.id, deal.seatId))
            else
                table.insert(seatsStillPlaying, seat)
                print(string.format("Table %d and seat %d is still playing", t.id, deal.seatId))
            end
            deal = table.remove(t.dealStack)
        end


        if cardsToDeal then
            print(string.format("Dealing additional cards to table %d", t.id))

            -- Send the information to the clients inside the casino
            BroadcastCasinoEvent("gl_casino:bj:dealCards", t.id, dealResult)

            Citizen.Wait(drawnCards * CARD_DELAY)

            print(string.format("Done dealing additional cards to table %d", t.id))
            local dealTime = GetGameTimer()
            for k,v in pairs(seatsStillPlaying) do
                v.lastActionTime = dealTime
                TriggerClientEvent("gl_casino:bj:playerRound", v.participantPed, true)
            end
        end

        local currentTime = GetGameTimer()
        local finished = true
        for k,v in pairs(t.seats) do
            if v.roundState == ROUND.BET then
                finished = false

                if (currentTime - v.lastActionTime) > PLAYER_ROUND_TIMEOUT then
                    finished = true
                    TriggerClientEvent("gl_casino:bj:playerRound", v.participantPed, false)
                    v.roundState = ROUND.DONE
                    print(string.format("Timeout waiting on action from table %d in seat %d", t.id, k))
                end
            end
        end

        if finished then
            roundActive = false
        end
    until not roundActive

    print(string.format("Dealer round on table %d", t.id))
    t.state = STATES.DEALER_ROUND
end

local function dealerRoundTick(t)
    -- Dealer check his card
    BroadcastCasinoEvent("gl_casino:bj:checkCards", t.id)

    Citizen.Wait(CHECK_DELAY)

    -- Dealer stand on 17 or more, so draw cards until we hit at least 17 or bust
    local drawnCards = 0
    local dealResult = {}
    local dealerValue = getBlackjackValue(t.dealerCards)
    print(string.format("Table %d dealer has hand value %d", t.id, dealerValue))
    while dealerValue < 17 do
        local card = drawCard(t.deck)
        table.insert(t.dealerCards, card)
        table.insert(dealResult, { seatId = 0, card = card})
        drawnCards = drawnCards + 1
        dealerValue = getBlackjackValue(t.dealerCards)
        print(string.format("Table %d dealer has hand value %d", t.id, dealerValue))
    end

    if drawnCards > 0 then
        BroadcastCasinoEvent("gl_casino:bj:dealCards", t.id, dealResult)
        Citizen.Wait(drawnCards * CARD_DELAY)
    end

    -- Check players win and hand out payouts
    for k,v in pairs(t.seats) do
        if v.participantPed then
            local won = false
            local tie = false
            local playerValue = getBlackjackValue(v.cards)

            if playerValue > 21 then
                won = false
            elseif dealerValue > 21 then
                won = true
            elseif playerValue > dealerValue then
                won = true
            elseif playerValue == dealerValue then
                won = false
                tie = true
            end

            local amountWon = 0
            if won then
                amountWon = (t.bet*3)//2
            elseif tie then
                amountWon = t.bet
            end

            TriggerClientEvent("gl_casino:bj:roundResult", v.participantPed, t.id, amountWon, playerValue, dealerValue)

            -- TODO : Register payout server side
        end
    end

    -- Remove the cards from the field
    local seatsCount = 1
    
    for k,v in pairs(t.seats) do
        if v.participantPed then
            seatsCount = seatsCount + 1
        end
    end

    BroadcastCasinoEvent("gl_casino:bj:removeCards", t.id)

    Citizen.Wait(seatsCount * REMOVE_DELAY)
    
    print(string.format("Waiting for player on table %d", t.id))
    t.state = STATES.WAITING_PLAYER
    resetTable(t)
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
    
    local t, seat = getTableAndSeat(src, tableId, seatId)
    if not t then
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

    local t, seat = getTableAndSeat(src, tableId, seatId)
    if not t then
        return
    end

    print(string.format("Player %d left table %d from seat %d", src, tableId, seatId))

    if seat.roundState ~= ROUND.BET and seat.roundState ~= ROUND.SKIP then
        seat.roundState = ROUND.SKIP
    end

    if seat.roundState == ROUND.BET then
        seat.roundState = ROUND.DONE
    end

    seat.occupied = false
    seat.ped = nil

    BroadcastCasinoEvent("gl_casino:bj:tableSeatFreed", tableId, seatId)
end
RegisterNetEvent("gl_casino:bj:playerLeaveTable", playerLeaveTable)

local function playerBetRound(tableId, seatId)
    local src = source

    local t, seat = getTableAndSeat(src, tableId, seatId)
    if not t then
        return
    end

    --TODO: Register bet amount (t.bet) server side
    seat.roundState = ROUND.BET
    seat.participantPed = src
    print(string.format("Participate in round for table %d and seat %d", tableId, seatId))
end
RegisterNetEvent("gl_casino:bj:playerBetRound", playerBetRound)

local function playerSkipRound(tableId, seatId)
    local src = source

    local t, seat = getTableAndSeat(src, tableId, seatId)
    if not t then
        return
    end

    seat.roundState = ROUND.SKIP
    seat.participantPed = src
    print(string.format("Skip round for table %d and seat %d", tableId, seatId))
end
RegisterNetEvent("gl_casino:bj:playerSkipRound", playerSkipRound)

local function playerStand(tableId, seatId)
    local src = source

    local t, seat = getTableAndSeat(src, tableId, seatId)
    if not t then
        return
    end

    seat.roundState = ROUND.DONE
    TriggerClientEvent("gl_casino:bj:playerRound", seat.participantPed, false)
    print(string.format("Stand for table %d and seat %d", tableId, seatId))
end
RegisterNetEvent("gl_casino:bj:playerStand", playerStand)

local function playerHitCard(tableId, seatId)
    local src = source

    local t, seat = getTableAndSeat(src, tableId, seatId)
    if not t then
        return
    end

    TriggerClientEvent("gl_casino:bj:playerRound", seat.participantPed, false)

    -- Deal card and continue or end round if bust
    local card = drawCard(t.deck)
    table.insert(seat.cards, card)
    table.insert(t.dealStack, { seatId = seatId, card = card})
    print(string.format("Draw card %s for table %d and seat %d", cardName(card), tableId, seatId))
end
RegisterNetEvent("gl_casino:bj:playerHitCard", playerHitCard)
