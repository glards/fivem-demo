
local blackjackValue = {
    11,
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

function getBlackjackValue(cards)
    local value = 0
    local aceCount = 0
    for k,v in pairs(cards) do
        local symbol = cardSymbol(v)
        local cv = blackjackValue[symbol]

        value = value + cv

        if symbol == 1 then
            aceCount = aceCount + 1
        end
    end

    while aceCount > 0 and value > 21 do
        aceCount = aceCount - 1
        value = value - 10
    end

    return value
end
