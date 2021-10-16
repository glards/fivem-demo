
RegisterNetEvent('gl_garage:spawn')

AddEventHandler('gl_garage:spawn', function (modelHash, posX, posY, posZ, head)
    local ped = GetPlayerPed(source)

    pos = vector3(posX, posY, posZ)
    local veh = CreateVehicle(modelHash, pos.x, pos.y, pos.z, head, true, false)
    SetPedIntoVehicle(ped, veh, -1)
end)