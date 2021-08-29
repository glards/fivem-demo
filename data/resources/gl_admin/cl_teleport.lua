
RegisterCommand('tp', function(source, args, rawCommand)
    local ped = PlayerPedId()
    print(ped)
    print(source)

    local pos = vector3(tonumber(args[1]) or 0, tonumber(args[2]) or 0, tonumber(args[3]) or 0)
    SetEntityCoords(ped, pos.x, pos.y, pos.z, true, true, true, false)
end, false)