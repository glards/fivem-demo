
RegisterNetEvent('gl_garage:spawn')

AddEventHandler('gl_garage:spawn', function (modelHash, posX, posY, posZ, head, movePlayerInside)
    local ped = GetPlayerPed(source)

    pos = vector3(posX, posY, posZ)
    local veh = CreateVehicle(modelHash, pos.x, pos.y, pos.z, head, true, false)
    if movePlayerInside then
        SetPedIntoVehicle(ped, veh, -1)
    end
end)