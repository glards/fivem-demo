
RegisterNetEvent('gl_garage:spawn')

AddEventHandler('gl_garage:spawn', function (modelHash, posX, posY, posZ, head)
    print(source)
    --local playerIdx = GetPlayerFromServerId(source)
    --local ped = GetPlayerPed(playerIdx)

    print(modelHash)
    pos = vector3(posX, posY, posZ)
    print(pos)
    print(head)
    local veh = CreateVehicle(modelHash, pos.x, pos.y, pos.z, head, true, false)
    print(veh)
    --SetPedIntoVehicle(ped, veh, -1)
end)