local PLAYER_CONTROL = 0

local INPUT_SPRINT = 21
local INPUT_JUMP = 22
local INPUT_MOVE_LR = 30
local INPUT_MOVE_UD = 31
local INPUT_DUCK = 36

local SET_COORDS_OFFSET = vector3(0,0,-1)
local DOWN = vector3(0,0,-1)

local MOVE_SPEED = 1.0
local SPRINT_FACTOR = 10.0


local isNoClip = false

function NoClip()
    local ped = PlayerPedId()

    DisableAllControlActions(ped)

    SetEntityCanBeDamaged(ped, false)
    SetEntityInvincible(ped, true)
    SetPlayerInvincible(ped, true)
    SetEntityAlpha(ped, 204, 0)

    FreezeEntityPosition(ped, true)
    SetEntityCollision(ped, false, false)

    while isNoClip do
        Citizen.Wait(0)

        SetLocalPlayerVisibleLocally(true)
        SetEveryoneIgnorePlayer(ped, true)

        local rightFactor = GetControlNormal(PLAYER_CONTROL, INPUT_MOVE_LR)
        local forwardFactor = -GetControlNormal(PLAYER_CONTROL, INPUT_MOVE_UD)
        local upFactor = GetControlNormal(PLAYER_CONTROL, INPUT_JUMP) - GetControlNormal(PLAYER_CONTROL, INPUT_DUCK)
        
        local speed = GetControlNormal(PLAYER_CONTROL, INPUT_SPRINT)

        local forward, right, up, pos = GetEntityMatrix(ped)
        
        local speedFactor = MOVE_SPEED*(1.0 + (SPRINT_FACTOR-1.0)*speed)
        local newPos = pos + (forward*forwardFactor*speedFactor) + (right*rightFactor*speedFactor) + (up*upFactor*speedFactor) + SET_COORDS_OFFSET

        SetEntityRotation(ped, GetGameplayCamRot(0), 0, false)
        SetEntityCoords(ped, newPos, true, true, true, false)
    end

    while math.abs(GetEntityHeightAboveGround(ped)) > 1.0 do
        Citizen.Wait(0);
        local pos = GetEntityCoords(ped)
        local newPos = pos + SET_COORDS_OFFSET + DOWN
        SetEntityCoords(ped, newPos, true, true, true, false)
    end

    FreezeEntityPosition(ped, false)
    SetEntityCollision(ped, true, true)

    while not IsPedStopped(ped) or IsPedFalling(ped) do
        Citizen.Wait(0);
    end
    
    ResetEntityAlpha(ped)

    NetworkSetEntityInvisibleToNetwork(ped, false)
    SetEntityVisible(ped, true, 0)
    SetLocalPlayerVisibleLocally(true)
    SetEveryoneIgnorePlayer(ped, false)

    SetEntityCanBeDamaged(ped, true)
    SetEntityInvincible(ped, false)
    SetPlayerInvincible(ped, false)
    EnableAllControlActions(ped)
end

function DrawText(x, y, text, ...)
    SetTextScale(0.0, 0.3)
    SetTextOutline()

    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(
        string.format(text, ...)
    )
    EndTextCommandDisplayText(x, y)
end

RegisterCommand('noclip', function()
    isNoClip = not isNoClip
    if isNoClip then
        Citizen.CreateThread(NoClip)
    end
end, false)


RegisterKeyMapping('noclip', 'Noclip', 'keyboard', 'F9')

