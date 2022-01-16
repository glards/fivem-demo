

BlackjackTable = {}

function BlackjackTable:New(id, data)
    local o = {
        id = id
    }
    for k,v in pairs(data) do
        o[k] = v
    end

    setmetatable(o, self)
    self.__index = self

    return o
end

