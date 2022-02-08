
function followNavMesh(ped, dest, heading)
    local p = promise.new()

    TaskFollowNavMeshToCoord(ped, dest, 1.0, 7000, 0.05, false, heading)

    Citizen.CreateThread(function ()
        repeat
            Citizen.Wait(0)
        until #(GetEntityCoords(ped).xy - dest.xy) <= 0.25
        Citizen.Wait(500)
        p:resolve()
    end)

    return p
end

function playAnim(ped, animDict, anim, flag)
    local p = promise.new()

    TaskPlayAnim(ped, animDict, anim, 8.0, 1.0, -1, flag, 0.0, 1.0, 0.0, 1.0)

    Citizen.CreateThread(function ()
        Citizen.Wait(100)
        while not isAnimFinished(ped, animDict, anim) do
            Citizen.Wait(100)
        end
        p:resolve()
    end)

    return p
end

function playAnimWithPos(ped, animDict, anim, pos, rot, flag)
    local p = promise.new()

    TaskPlayAnimAdvanced(ped, animDict, anim, pos, rot, 8.0, 1.0, -1, flag, 0.0, 1.0, 0.0, 1.0)

    Citizen.CreateThread(function ()
        Citizen.Wait(100)
        while not isAnimFinished(ped, animDict, anim) do
            Citizen.Wait(100)
        end
        p:resolve()
    end)

    return p
end

function animDebug(frame, ped, animDict, anim)
    local entityPlayingAnim = IsEntityPlayingAnim(ped, animDict, anim, 3)
    local hasEntityAnimFinished = HasEntityAnimFinished(ped, animDict, anim, 3)
    local currentTime = GetEntityAnimCurrentTime(ped, animDict, anim)
    local totalTime = GetEntityAnimTotalTime(ped, animDict, anim)
    print("---------- Start frame", frame ,"------------")
    print("IsEntityPlayingAnim", entityPlayingAnim)
    print("HasEntityAnimFinished", hasEntityAnimFinished)
    print("GetEntityAnimCurrentTime", currentTime)
    print("GetEntityAnimTotalTime", totalTime)
    print("---------- End frame", frame ,"------------")
end

function isAnimFinished(ped, animDict, anim)
    local entityPlayingAnim = IsEntityPlayingAnim(ped, animDict, anim, 3)
    local hasEntityAnimFinished = HasEntityAnimFinished(ped, animDict, anim, 3)

    if entityPlayingAnim and hasEntityAnimFinished then
        return true
    end

    if not entityPlayingAnim and not hasEntityAnimFinished then
        return true
    end

    return false
end


function playNetworkSynchronizedScene(ped, animDict, anim, pos, rot, holdLastFrame, looped, blendInSpeed, blendOutSpeed, duration, flag, playbackRate)
    local p = promise.new()

    local sceneId = NetworkCreateSynchronisedScene(pos, rot, 2, holdLastFrame, looped, 1.0, 0.0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, sceneId, animDict, anim, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, 0)

    NetworkStartSynchronisedScene(sceneId)

    Citizen.CreateThread(function ()
        Citizen.Wait(100)
        while not isAnimFinished(ped, animDict, anim) do
            Citizen.Wait(100)
        end
        p:resolve()
    end)

    return p
end

function playNetworkSynchronizedSceneWithObject(ped, objectHash, objectAnim, animDict, anim, pos, rot, holdLastFrame, looped, blendInSpeed, blendOutSpeed, duration, flag, playbackRate)
    local p = promise.new()

    local sceneId = NetworkCreateSynchronisedScene(pos, rot, 2, holdLastFrame, looped, 1.0, 0.0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, sceneId, animDict, anim, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, 0)

    Citizen.InvokeNative(0x45F35C0EDC33B03B, sceneId, objectHash, pos, animDict, objectAnim, 2.0, -1.5, 13)

    NetworkStartSynchronisedScene(sceneId)

    Citizen.CreateThread(function ()
        Citizen.Wait(100)
        while not isAnimFinished(ped, animDict, anim) do
            Citizen.Wait(100)
        end
        p:resolve()
    end)

    return p
end

function playSynchronizedScene(ped, animDict, anim, pos, rot, holdLastFrame, looped, blendInSpeed, blendOutSpeed, duration, flag, playbackRate)
    local p = promise.new()

    local sceneId = CreateSynchronizedScene(pos, rot, 2, holdLastFrame, looped, 1.0, 0.0, 1.0)

    TaskSynchronizedScene(ped, sceneId, animDict, anim, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, 0)

    Citizen.CreateThread(function ()
        repeat
            Citizen.Wait(0)
        until GetSynchronizedScenePhase(sceneId) >= 0.99
        p:resolve()
    end)

    return p
end

function loadModels(models)
    if type(models) == "table" then
        for i=1,#models do
            local hash = models[i]
            if hash ~= nil then
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Citizen.Wait(0)
                end
            end
        end
    elseif type(models) == "string" then
        RequestModel(models)
        while not HasModelLoaded(models) do
            Citizen.Wait(0)
        end
    end
end

function loadAnimDicts(dicts)
    if type(dicts) == "table" then
        for i=1,#dicts do
            local dict = dicts[i]
            if dict ~= nil then
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    Citizen.Wait(0)
                end
            end
        end
    elseif type(dicts) == "string" then
        RequestAnimDict(dicts)
        while not HasAnimDictLoaded(dicts) do
            Citizen.Wait(0)
        end
    end
end

exports('followNavMesh', followNavMesh)
exports('playAnim', playAnim)
exports('playAnimWithPos', playAnimWithPos)
exports('playNetworkSynchronizedScene', playNetworkSynchronizedScene)
exports('playNetworkSynchronizedSceneWithObject', playNetworkSynchronizedSceneWithObject)
--exports('playSynchronizedScene', playSynchronizedScene)
exports('loadModels', loadModels)
exports('loadAnimDicts', loadAnimDicts)