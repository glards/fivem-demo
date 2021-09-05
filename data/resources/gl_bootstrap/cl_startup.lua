local clientIsRunning = true
local displayInfo = false

function ClientThread()
    SetPoliceIgnorePlayer(ped, true)
    SetMaxWantedLevel(0)

    while clientIsRunning do
        Citizen.Wait(0)

        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            SetUserRadioControlEnabled(false)
            if GetPlayerRadioStationName() ~= nil then
                SetVehRadioStation(GetVehiclePedIsIn(ped),"OFF")
            end
        end

        if displayInfo then
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            SetTextScale(0.0, 0.3)
            SetTextOutline()

            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName(
                string.format("~r~Coords :~s~~n~X: %.2f~n~Y: %.2f~n~Z: %.2f~n~H: %.2f",
                    coords.x,
                    coords.y,
                    coords.z,
                    heading)
            )
            EndTextCommandDisplayText(0, 0.5)
        end
    end
end
Citizen.CreateThread(ClientThread)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        print('Starting bootstrap')
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        print('Stopping bootstrap')
        clientIsRunning = false
    end
end)


RegisterCommand('info', function()
    displayInfo = not displayInfo
end, false)
