
local Portals = {}
local PortalNameMap = {}

function addPortals(p)
    newPortals = {}
    for i=1,#Portals do
        local found = false
        for j=1,#p do
            if Portals[i].Name == p[j].Name then
                found = true
            end
        end
        if not found then
            table.insert(newPortals, Portals[i])
        end
    end
    for i=1,#p do
        table.insert(newPortals, p[i])
    end
    Portals = newPortals
    PortalNameMap = makeMap(Portals)
end
exports('addPortals', addPortals)

function makeMap(portals)
    portals = portals or {}
    local m = {}

    for i=1,#Portals do
        m[portals[i].Name] = i
    end

    return m
end

function findPortalByName(name)
    local otherPortalId = PortalNameMap[name]
    if otherPortalId == nil then
        return nil
    end

    return Portals[otherPortalId]
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for i=1,#Portals do
            local portal = Portals[i]
            DrawMarker(23, portal.Pos.x, portal.Pos.y, portal.Pos.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 255, false, true, 2, nil, nil, false)

            local dist = #(coords - portal.Pos.xyz)

            if dist < 1.5 and IsControlJustPressed(0, 38) then
                local otherPortal = findPortalByName(portal.LinkTo)
                if otherPortal ~= nil then
                    DoScreenFadeOut(500)
                    Citizen.Wait(500)
                    SetEntityCoords(ped, otherPortal.Pos.x, otherPortal.Pos.y, otherPortal.Pos.z, true, true, true, false)
                    SetEntityHeading(ped, otherPortal.Pos.w)
                    DoScreenFadeIn(500)
                    if portal.Trigger ~= nil then
                        portal.Trigger()
                    end
                else
                    print('Unable to find other portal')
                end
            end
        end
    end
end)

RegisterCommand('portals', function(source, args, rawCommand)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    for k,v in pairs(Portals) do
        print(string.format("%d: %s -> %s (Pos: %s / Dist: %2f)", k, v.Name, v.LinkTo, v.Pos, #(coords - v.Pos.xyz)))
    end
end, false)
