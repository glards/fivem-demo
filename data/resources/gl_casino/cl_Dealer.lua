
Dealer = {}

function Dealer:New(pos, heading)
    local o = {
        pos = pos,
        heading = heading
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

