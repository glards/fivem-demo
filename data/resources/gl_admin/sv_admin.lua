


RegisterCommand('identifiers', function(source)
    local identifiers = GetPlayerIdentifiers(source)
    for i,identifier in ipairs(identifiers) do
        print('Player identifier #' .. i .. ': ' .. identifier)
    end
end, false)


local function ping(clientTimestamp)
    local src = source

    local currentTimestamp = GetGameTimer()
    TriggerClientEvent('gl_admin:pong', src, clientTimestamp, currentTimestamp)
end
RegisterNetEvent('gl_admin:ping', ping)