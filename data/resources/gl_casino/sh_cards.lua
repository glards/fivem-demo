
local cardSuitName = {
    'Trèfle',
    'Carreau',
    'Coeur',
    'Pique'
}

local cardSymbolName = {
    'As',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'Valet',
    'Dame',
    'Roi'
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

function createDeck()
    local deck = {}
    return deck
end

function drawCard(deck)
    local validDraw = false
    local card = nil
    repeat
        card = math.random(1, #cards)

        if deck[card] == nil then
            validDraw = true
            deck[card] = false
        end
    until validDraw

    return card
end

function suitName(suit)
    assert(suit >= 1 and suit <= #cardSuitName)
    return cardSuitName[suit]
end

function symbolName(symbol)
    assert(symbol >= 1 and symbol <= #cardSymbolName)
    return cardSymbolName[symbol]
end

function cardSuit(card)
    assert(card >= 1 and card <= #cards)
    return math.floor((card - 1) / 13) + 1
end

function cardSymbol(card)
    assert(card >= 1 and card <= #cards)
    return ((card - 1) % 13) + 1
end

function cardHash(card)
    assert(card >= 1 and card <= #cards)
    return cards[card]
end

function cardName(card)
    local suit = cardSuit(card)
    local symbol = cardSymbol(card)

    return symbolName(symbol) .. ' de ' .. suitName(suit)
end
