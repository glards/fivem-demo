


RegisterCommand('identifiers', function(source)
    local identifiers = GetPlayerIdentifiers(source)
    for i,identifier in ipairs(identifiers) do
        print('Player identifier #' .. i .. ': ' .. identifier)
    end
end, false)
