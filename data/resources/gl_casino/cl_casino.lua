
exports.gl_interaction:addPortals({
    {
        Name = "Casino_interior",
        Pos = vector4(1089.88, 206.43, -50.00, 344.95),
        LinkTo = "Casino_exterior",
        Trigger = function ()
            leaveCasino()
        end
    },
    {
        Name = "Casino_exterior",
        Pos = vector4(935.69, 46.69, 80.10, 132.15),
        LinkTo = "Casino_interior",
        Trigger = function ()
            enterCasino()
        end
    },
    {
        Name = "Casino_elevator_inside",
        Pos = vector4(1085.34, 214.57, -50.20, 307.23),
        LinkTo = "Casino_elevator_rooftop",
        Trigger = function ()
            leaveCasino()
        end
    },
    {
        Name = "Casino_elevator_rooftop",
        Pos = vector4(964.66, 58.74, 111.55, 70.0),
        LinkTo = "Casino_elevator_inside",
        Trigger = function ()
            enterCasino()
        end
    }
})

-- Taken from \update\x64\dlcpacks\mpvinewood\dlc.rpf\x64\levels\gta5\interiors\int_placement_vw.rpf\vw_casino_main.ymap
CasinoBoundingBox = {
    min = vector3(1073.997, 189.5872, -53.83894),
    max = vector3(1166.935, 284.8898, -42.28554)
}

function isInsideBbox(coords, bbox)
    return coords.x > bbox.min.x and coords.x < bbox.max.x and
           coords.y > bbox.min.y and coords.y < bbox.max.y and
           coords.z > bbox.min.z and coords.z < bbox.max.z
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    print("onResourceStart Client Casino")

    local ped = PlayerPedId()

    local coords = GetEntityCoords(ped)
    if isInsideBbox(coords, CasinoBoundingBox) then
        enterCasino()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    print("onResourceStop Client Casino")
    leaveCasino()
end)


function enterCasino()
    print("Entering casino")

    local interior = GetInteriorAtCoords(GetEntityCoords(GetPlayerPed(-1)))
    while not IsInteriorReady(interior) do
        Citizen.Wait(0)
    end

    TriggerServerEvent('gl_casino:playerEnterCasino')
    startWallVideo()
    startSlotMachines()
    startLuckyWheel()
end

function leaveCasino()
    print("Leaving casino")

    TriggerServerEvent('gl_casino:playerLeaveCasino')
    stopWallVideo()
    stopSlotMachines()
    stopLuckyWheel()
end

local running = false
local showBigWin = false
local videoWallRenderTarget = nil

function startWallVideo()
    if running then
        return
    end

    running = true

    RequestStreamedTextureDict('Prop_Screen_Vinewood')
    while not HasStreamedTextureDictLoaded('Prop_Screen_Vinewood') do
        Citizen.Wait(0)
    end

    RegisterNamedRendertarget('casinoscreen_01')
    LinkNamedRendertarget(`vw_vwint01_video_overlay`)
    videoWallRenderTarget = GetNamedRendertargetRenderId('casinoscreen_01')

    Citizen.CreateThread(wallVideoThread)
end

function stopWallVideo()
    if not running then
        return
    end

    running = false
end

function wallVideoThread()
    local lastUpdatedTvChannel = GetGameTimer()

    setVideoWallTvChannel()

    while running do
        Citizen.Wait(0)

        local currentTime = GetGameTimer()
        if showBigWin then
            setVideoWallTvChannelWin()

            lastUpdatedTvChannel = GetGameTimer() - 33666
            showBigWin           = false
        else
            if (currentTime - lastUpdatedTvChannel) >= 42666 then
                setVideoWallTvChannel()

                lastUpdatedTvChannel = currentTime
            end
        end
        -- if (currentTime - lastUpdatedTvChannel) >= 42666 then
        --     setVideoWallTvChannel()

        --     lastUpdatedTvChannel = currentTime
        -- end

        SetTextRenderId(videoWallRenderTarget)
        SetScriptGfxDrawOrder(4)
        SetScriptGfxDrawBehindPausemenu(true)
        DrawInteractiveSprite('Prop_Screen_Vinewood', 'BG_Wall_Colour_4x4', 0.25, 0.5, 0.5, 1.0, 0.0, 255, 255, 255, 255)
        DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        SetTextRenderId(GetDefaultScriptRendertargetRenderId())
    end

    ReleaseNamedRendertarget('casinoscreen_01')
end
-- CASINO_DIA_PL    - Falling Diamonds
-- CASINO_HLW_PL    - Falling Skulls
-- CASINO_SNWFLK_PL - Falling Snowflakes
function setVideoWallTvChannel()
    SetTvChannelPlaylist(0, 'CASINO_SNWFLK_PL', true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(0)
end

function setVideoWallTvChannelWin()
    SetTvChannelPlaylist(0, 'CASINO_WIN_PL', true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(-1)
    SetTvChannel(0)
end

RegisterCommand('bigwin', function(source, args, rawCommand)
    showBigWin = true
end, false)

