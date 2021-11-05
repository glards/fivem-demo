local clientIsRunning = true
local displayInfo = false

local SET_COORDS_OFFSET = vector3(0,0,-1)

function ClientThread()
    SetPoliceIgnorePlayer(ped, true)
    SetMaxWantedLevel(0)

    local shapeTestHandle = nil
    local lastMaterial = nil
    local lastEntity = nil

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

            ShowHudComponentThisFrame(14)

            SetTextScale(0.0, 0.3)
            SetTextOutline()

            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName(
                string.format("~r~Coords :~s~~n~X: %.2f~n~Y: %.2f~n~Z: %.2f~n~H: %.2f~n~",
                    coords.x,
                    coords.y,
                    coords.z,
                    heading)
            )
            EndTextCommandDisplayText(0, 0.5)

            local cameraRotation = GetGameplayCamRot()
            local cameraCoord = GetGameplayCamCoord()
            
            local cameraRotationRad = math.rad(cameraRotation)

            local camForwardVec = norm(vector3(
                -math.sin(cameraRotationRad.z)*math.abs(math.cos(cameraRotationRad.x)),
                math.cos(cameraRotationRad.z)*math.abs(math.cos(cameraRotationRad.x)),
                math.sin(cameraRotationRad.x)
            ))

            local newPos = cameraCoord+camForwardVec*20.0

            if shapeTestHandle == nil then
                shapeTestHandle = StartShapeTestLosProbe(cameraCoord.x, cameraCoord.y, cameraCoord.z, newPos.x, newPos.y, newPos.z, -1, 0, 4)
            else
                local retval --[[ integer ]],
                    hit --[[ boolean ]],
                    endCoords --[[ vector3 ]],
                    surfaceNormal --[[ vector3 ]],
                    materialHash --[[ Hash ]],
                    entityHit --[[ Entity ]] = GetShapeTestResultIncludingMaterial(shapeTestHandle)
                
                if retval == 2 then
                    if hit then
                        lastMaterial = materialHash
                        lastEntity = ""
                        
                        if entityHit ~= 0 then
                            lastEntity = "" .. entityHit
                            local entityType = GetEntityType(entityHit)
                            if entityType == 1 then
                                lastEntity = lastEntity .. " Ped " .. entityHit
                            elseif entityType == 2 then
                                local plate = GetVehicleNumberPlateText(entityHit)
                                lastEntity = lastEntity .. " Vehicle " .. plate
                            elseif entityType == 3 then
                                local hash = GetEntityModel(entityHit)
                                lastEntity = lastEntity .. " Object " .. hash
                            end
                        end
                    else
                        lastMaterial = ""
                        lastEntity = ""
                    end

                    shapeTestHandle = nil
                end
            end

            SetTextScale(0.0, 0.3)
            SetTextOutline()
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName(
                string.format("MAT: %s~n~ENT: %s",
                    lastMaterial,
                    lastEntity)
            )
            EndTextCommandDisplayText(0, 0.15)
        end
    end
end
Citizen.CreateThread(ClientThread)

Citizen.CreateThread(function()
	while true do
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()
		Wait(1000)
	end
end)

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
