


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


AddEventHandler("playerEnteredScope", function(data)
    local playerEntering, player = data["player"], data["for"]
    print(("%s is entering %s's scope"):format(playerEntering, player))
end)

AddEventHandler("playerLeftScope", function(data)
    local playerLeaving, player = data["player"], data["for"]
    print(("%s is leaving %s's scope"):format(playerLeaving, player))
end)