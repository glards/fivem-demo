RegisterCommand('tp', function(source, args, rawCommand)
    local ped = PlayerPedId()

    local pos = vector3(tonumber(args[1]) or 0, tonumber(args[2]) or 0, tonumber(args[3]) or 0)
    SetEntityCoords(ped, pos.x, pos.y, pos.z, true, true, true, false)
end, false)

RegisterCommand('unstuck', function(source, args, rawCommand)
    local ped = PlayerPedId()

    TaskPlayAnim(ped, 'amb@code_human_wander_smoking_fat@male@base', 'static', 8.0,8.0,-1,0,1.0,0.0,0.0,0.0)
    ClearPedTasksImmediately(ped)
end, false)

RegisterCommand('ping', function(source, args, rawCommand)
    local ped = PlayerPedId()

    local currentTimestamp = GetGameTimer()
    TriggerServerEvent('gl_admin:ping', currentTimestamp)
end, false)

local function pong(clientTimestamp, serverTimestamp)
    local currentTimestamp = GetGameTimer()

    local rtt = currentTimestamp - clientTimestamp
    local ping = serverTimestamp - clientTimestamp

    print(string.format("RTT : %d ms | Ping : %d ms", rtt, ping))
end
RegisterNetEvent('gl_admin:pong', pong)

