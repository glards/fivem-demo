
local golfRunning = true

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
    while golfRunning do
        Citizen.Wait(0)

        local coord = GetEntityCoords(ped)

    end

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


