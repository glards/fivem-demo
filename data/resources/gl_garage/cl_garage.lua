
RegisterCommand('svspawn', function(source, args, rawCommand)
    local vehicleName = args[1] or 'adder'

    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        print('Unable to spawn vehicle '.. vehicleName)
        return
    end

    local ped = PlayerPedId()
    local forward, right, up, pos = GetEntityMatrix(ped)
    local head = GetEntityHeading(ped)

    --pos = pos + forward*5

    print(vehicleName)
    print(pos)
    print(head)
    TriggerServerEvent('gl_garage:spawn', vehicleName, pos.x, pos.y, pos.z, head)

end, false)
