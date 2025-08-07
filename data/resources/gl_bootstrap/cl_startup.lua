local clientIsRunning = true
local displayInfo = false

local SET_COORDS_OFFSET = vector3(0,0,-1)

local glm = require("glm")

-- Cache common functions
local vec3 = vec3
local quat = quat
local glm_abs = glm.abs
local glm_deg = glm.deg
local glm_dot = glm.dot
local glm_rad = glm.rad
local glm_sign = glm.sign
local glm_approx = glm.approx

-- Cache direction vectors
local glm_up = glm.up()
local glm_right = glm.right()
local glm_forward = glm.forward()

function ScreenPositionToCameraRay(screenX, screenY)
    local pos = GetFinalRenderedCamCoord()
    local rot = glm_rad(GetFinalRenderedCamRot(2))

    local q = glm.quatEulerAngleZYX(rot.z, rot.y, rot.x)
    return pos,glm.rayPicking(
        q * glm_forward,
        q * glm_up,
        glm_rad(GetFinalRenderedCamFov()),
        GetAspectRatio(true),
        0.10000, -- GetFinalRenderedCamNearClip(),
        10000.0, -- GetFinalRenderedCamFarClip(),
        screenX * 2 - 1, -- scale mouse coordinates from [0, 1] to [-1, 1]
        screenY * 2 - 1
    )
end

function ClientThread()
    SetPoliceIgnorePlayer(ped, true)
    SetMaxWantedLevel(0)

    local shapeTestHandle = nil
    local lastMaterial = ""
    local lastEntity = ""
    local lastNormal = ""
    local lastPos = ""

    while clientIsRunning do
        Citizen.Wait(0)

        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            SetUserRadioControlEnabled(false)
            if GetPlayerRadioStationName() then
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
            
            local cameraRotationRad = vector3(math.rad(cameraRotation.x), math.rad(cameraRotation.y), math.rad(cameraRotation.z))

            local camForwardVec = norm(vector3(
                -math.sin(cameraRotationRad.z)*math.abs(math.cos(cameraRotationRad.x)),
                math.cos(cameraRotationRad.z)*math.abs(math.cos(cameraRotationRad.x)),
                math.sin(cameraRotationRad.x)
            ))

            local newPos = cameraCoord+camForwardVec*20.0

            
            local r_pos,r_dir = ScreenPositionToCameraRay(0.5, 0.5)
            local b = r_pos + 10000 * r_dir

            if shapeTestHandle == nil then
                shapeTestHandle = StartExpensiveSynchronousShapeTestLosProbe(r_pos.x,r_pos.y,r_pos.z, b.x,b.y,b.z, 1|2|8|16, PlayerPedId(), 7)
                --shapeTestHandle = StartShapeTestLosProbe(cameraCoord.x, cameraCoord.y, cameraCoord.z, newPos.x, newPos.y, newPos.z, -1, 0, 4)
            else
                local retval,hit,endCoords,surfaceNormal,entityHit = GetShapeTestResult(shapeTestHandle)
                -- local retval --[[ integer ]],
                --     hit --[[ boolean ]],
                --     endCoords --[[ vector3 ]],
                --     surfaceNormal --[[ vector3 ]],
                --     materialHash --[[ Hash ]],
                --     entityHit --[[ Entity ]] = GetShapeTestResultIncludingMaterial(shapeTestHandle)
                surfaceNormal = glm.normalize(surfaceNormal)
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

                        lastNormal = string.format("%2f %2f %2f", surfaceNormal.x,  surfaceNormal.y, surfaceNormal.z)
                        lastPos = string.format("%2f %2f %2f", endCoords.x,  endCoords.y, endCoords.z)
                    else
                        lastMaterial = ""
                        lastEntity = ""
                        lastNormal = ""
                        lastPos = ""
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

            SetTextScale(0.0, 0.3)
            SetTextOutline()
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName(
                string.format("POS: %s~n~NORMAL: %s",
                    lastPos,
                    lastNormal)
            )
            EndTextCommandDisplayText(0, 0.25)
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
