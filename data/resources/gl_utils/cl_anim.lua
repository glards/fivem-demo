
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

    local duration = GetAnimDuration(animDict, anim)

    TaskPlayAnim(ped, animDict, anim, 8.0, 1.0, -1, flag, 0.0, 1.0, 0.0, 1.0)

    Citizen.CreateThread(function ()
        Citizen.Wait(duration*1000.0)
        p:resolve()
    end)

    return p
end

function playAnimWithPos(ped, animDict, anim, pos, rot, flag)
    local p = promise.new()

    local duration = GetAnimDuration(animDict, anim)

    TaskPlayAnimAdvanced(ped, animDict, anim, pos, rot, 8.0, 1.0, -1, flag, 0.0, 1.0, 0.0, 1.0)

    Citizen.CreateThread(function ()
        Citizen.Wait(duration*1000.0)
        p:resolve()
    end)

    return p
end


function playNetworkSynchronizedScene(ped, animDict, anim, pos, rot, holdLastFrame, looped, blendInSpeed, blendOutSpeed, duration, flag, playbackRate)
    local p = promise.new()

    local sceneId = NetworkCreateSynchronisedScene(pos, rot, 2, holdLastFrame, looped, 1.0, 0.0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, sceneId, animDict, anim, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, 0)

    NetworkStartSynchronisedScene(sceneId)

    local duration = GetAnimDuration(animDict, anim)

    Citizen.CreateThread(function ()
        Citizen.Wait(duration*1000.0)
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

    local duration = GetAnimDuration(animDict, anim)

    Citizen.CreateThread(function ()
        Citizen.Wait(duration*1000.0)
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
    for i=1,#models do
        local hash = models[i]
        if hash ~= nil then
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Citizen.Wait(0)
            end
        end
    end
end

function loadAnimDicts(dicts)
    for i=1,#dicts do
        local dict = dicts[i]
        if dict ~= nil then            
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(0)
            end
        end
    end
end

exports('followNavMesh', followNavMesh)
exports('playAnim', playAnim)
exports('playAnimWithPos', playAnimWithPos)
exports('playNetworkSynchronizedScene', playNetworkSynchronizedScene)
exports('playNetworkSynchronizedSceneWithObject', playNetworkSynchronizedSceneWithObject)
exports('playSynchronizedScene', playSynchronizedScene)
exports('loadModels', loadModels)
exports('loadAnimDicts', loadAnimDicts)