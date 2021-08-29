

RegisterCommand('spawn', function(source, args, rawCommand)
    local vehicleName = args[1] or 'adder'
    local ped = PlayerPedId()

    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        print('Unable to spawn vehicle '.. vehicleName)
        return
    end

    RequestModel(vehicleName)

    while not HasModelLoaded(vehicleName) do
        Wait(0)
    end

    local forward, right, up, pos = GetEntityMatrix(ped)
    local head = GetEntityHeading(ped)

    pos = pos + forward*5
    local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, head, true, false)

    SetModelAsNoLongerNeeded(vehicleName)
    SetEntityAsNoLongerNeeded(vehicle)

end, false)