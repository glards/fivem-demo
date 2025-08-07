
RegisterCommand('svspawn', function(source, args, rawCommand)
    local vehicleName = args[1] or 'adder'

    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        print('Unable to spawn vehicle '.. vehicleName)
        return
    end

    local movePlayerInside = true
    local ped = PlayerPedId()
    local forward, right, up, pos = GetEntityMatrix(ped)
    local head = GetEntityHeading(ped)

    if #args == 5 then
        pos = vector3(tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
        head = tonumber(args[5])
        movePlayerInside = false
    end

    TriggerServerEvent('gl_garage:spawn', vehicleName, pos.x, pos.y, pos.z, head, movePlayerInside)

end, false)
