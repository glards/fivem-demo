
local golfRunning = false
local trailShown = false

-- from func_1209
local holes = {
    [1] = {
        RadarZoomFactor = 0.81,
        MinimapPosition = vec2(-1222.0, 83.0),
        GreenRadarZoomFactor = 0.003,
        GreenMinimapPosition = vec2(-1142.0, 156.0),
        MinimapAngle = 280,
        HolePos = vec3(-1114.121, 220.789, 63.78)
    },
    [2] = {
        RadarZoomFactor = 0.75,
        MinimapPosition = vec2(-1216.0, 247.0),
        GreenRadarZoomFactor = 0.001,
        GreenMinimapPosition = vec2(-1294.0, 195.0),
        MinimapAngle = 89.0,
        HolePos = vec3(-1322.07, 158.77, 56.69)
    },
    [3] = {
        RadarZoomFactor = 0.1,
        MinimapPosition = vec2(-1274.5, 65.0),
        GreenRadarZoomFactor = 0.003,
        GreenMinimapPosition = vec2(-1142.0, 156.0),
        MinimapAngle = 264.0,
        HolePos = vec3(-1237.419, 112.988, 56.086)
    },
    [4] = {
        RadarZoomFactor = 0.55,
        MinimapPosition = vec2(-1197.0, 1.0),
        GreenRadarZoomFactor = 0.1,
        GreenMinimapPosition = vec2(-1274.5, 65.0),
        MinimapAngle = 232.0,
        HolePos = vec3(-1096.541, 7.848, 49.63)
    },
    [5] = {
        RadarZoomFactor = 0.75,
        MinimapPosition = vec2(-1090.0, -70.0),
        GreenRadarZoomFactor = 0.001,
        GreenMinimapPosition = vec2(-1004.0, -92.0),
        MinimapAngle = 220.0,
        HolePos = vec3(-957.386, -90.412, 39.161)
    },
    [6] = {
        RadarZoomFactor = 0.4,
        MinimapPosition = vec2(-1051.0, -55.0),
        GreenRadarZoomFactor = 0.001,
        GreenMinimapPosition = vec2(-1076.0, -76.0),
        MinimapAngle = 90.0,
        HolePos = vec3(-1103.516, -115.163, 40.444)
    },
    [7] = {
        RadarZoomFactor = 0.75,
        MinimapPosition = vec2(-1164.0, 40.0),
        GreenRadarZoomFactor = 0.085,
        GreenMinimapPosition = vec2(-1250.0, 34.0),
        MinimapAngle = 57.0,
        HolePos = vec3(-1290.633, 2.771, 49.219)
    },
    [8] = {
        RadarZoomFactor = 0.825,
        MinimapPosition = vec2(-1212.0, -120.0),
        GreenRadarZoomFactor = 0.001,
        GreenMinimapPosition = vec2(-1097.0, -109.0),
        MinimapAngle = 240.0,
        HolePos = vec3(-1034.944, -83.144, 42.919)
    },
    [9] = {
        RadarZoomFactor = 0.675,
        MinimapPosition = vec2(-1173.0, 117.0),
        GreenRadarZoomFactor = 0.001,
        GreenMinimapPosition = vec2(-1242.0, 106.0),
        MinimapAngle = 63.0,
        HolePos = vec3(-1294.775, 83.51, 53.804)
    }
}

RegisterCommand('golfon', function(source, args, rawCommand)
    local hole = 1

    golfRunning = true
    Citizen.CreateThread(golfThread)
end, false)

function golfThread()
    local hole = 1
    local ped = PlayerPedId()
    local data = holes[hole]

    -- Setup minimap
    SetBigmapActive(false, true)

    SetMinimapGolfCourse(hole)
    ToggleStealthRadar(false)

    -- Set the other minimap properties for this specific hole:
    SetRadarZoom(math.ceil(1100.0*data.RadarZoomFactor))
    LockMinimapPosition(data.MinimapPosition.x, data.MinimapPosition.y)
    LockMinimapAngle(data.MinimapAngle)

    -- Create the flag blip and set the sprite to the flag sprite.
    local flag = AddBlipForCoord(data.HolePos.x, data.HolePos.y, data.HolePos.z)
    SetBlipSprite(flag, 358)

    -- Create golfbag
    local golfbag = CreateObjectNoOffset(`prop_golf_bag_01b`,0,0,0,true,true,false)

    local cnt = 10

    local xPos = (-0.225 - (-0.444))
    local yPos = -1.111
    local zPos = 0.57

    local xRot = 0
    local yRot = 0
    local zRot = (-87.0 + (180.0))

    AttachEntityToEntity(golfbag, ped, 0, xPos, yPos, zPos, xRot, yRot, zRot, false, false, false, false, 2, true)

    while golfRunning do
        Citizen.Wait(0)

        local coord = GetEntityCoords(ped)

    end

    -- Remove golf bag
    if DoesEntityExist(golfbag) then
        DeleteEntity(golfbag)
    end

    -- Remove flag blip
    RemoveBlip(flag)

    SetMinimapGolfCourseOff()
    UnlockMinimapAngle()
    UnlockMinimapPosition()
    SetRadarZoom(0)
    ToggleStealthRadar(true)
end

function setupMinimap()
end

RegisterCommand('golfoff', function(source, args, rawCommand)
    golfRunning = false
end, false)


Citizen.CreateThread(function()
    RequestIpl('GolfFlags')
end)

RegisterCommand('trailon', function(source, args, rawCommand)
    trailShown = true
    Citizen.CreateThread(trailThread)
end)

function trailThread()
    GolfTrailSetRadius(0.025, 0.3, 0.025)
    GolfTrailSetColour(255.0,255.0,255.0,100.0,255.0,255.0,255.0,100.0,255.0,255.0,255.0,100.0)
    GolfTrailSetShaderParams(1.0,1.0,1.0,1.0,0.3)
    

    local ped = PlayerPedId()
    local coord = GetEntityCoords(ped)

    GolfTrailSetTessellation(8, 10)
    GolfTrailSetPath(coord.x, coord.y, coord.z, 50.0, 0.0, 25.0, 0.1, coord.z , false)

    GolfTrailSetEnabled(true)

    print("MaxHeight : %.2f", GolfTrailGetMaxHeight())
    for i=1,8 do
        local cp = GolfTrailGetVisualControlPoint(i-1)
        print(string.format("X: %.2f / Y: %.2f / Z: %.2f", cp.x, cp.y, cp.z))
    end

    while trailShown do
        Citizen.Wait(0)

        -- local maxHeight = GolfTrailGetMaxHeight()
        -- local cp = GolfTrailGetVisualControlPoint(7)

        -- SetTextScale(0.0, 0.3)
        -- SetTextOutline()

        -- BeginTextCommandDisplayText('STRING')
        -- AddTextComponentSubstringPlayerName(
        --     string.format("~r~maxHeight :%.2f~s~~n~X: %.2f~n~Y: %.2f~n~Z: %.2f",
        --         maxHeight,
        --         cp.x, cp.y, cp.z
        --     )
        -- )
        -- EndTextCommandDisplayText(0, 0.75)

    end

    GolfTrailSetEnabled(false)

end

RegisterCommand('trailoff', function(source, args, rawCommand)
    trailShown = false
end)