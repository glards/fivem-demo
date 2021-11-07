
local roulettePos = {
    vector4(1144.814, 268.2634, -52.8409, -135.0),
    vector4(1150.355, 262.7224, -52.8409, 45.0),
    vector4(1133.958, 262.1071, -52.0409, 135.0),
    vector4(1129.595, 267.2637, -52.0409, -45.0),
    vector4(1144.618, 252.2411, -52.0409, -45.0),
    vector4(1148.981, 247.0846, -52.0409, 135.0)
}

local dealerOffset = vector3(-0.68, 0.97, 0.0)

local dealers = {
    `s_f_y_casino_01`,
    `S_M_Y_Casino_01`
}

local rouletteProp = {
    `vw_prop_casino_roulette_01`,
    `vw_prop_casino_roulette_01b`
}

local markerProp = {
    `vw_prop_vw_marker_01a`,
    `vw_prop_vw_marker_02a`
}

local rouletteBallProp = `vw_prop_roulette_ball`

function createRoulette()
    local roulette = {}

    roulette.__index = roulette

    function roulette:new()
        local o = {}
        setmetatable(o, roulette)
        return o
    end

    function roulette:tick()
    end

    return roulette
end


Citizen.CreateThread(function()
    CreateDealer()

    CreateRoulette()
end)

function CreateDealer()
    for i=1,#dealers do
        local hash = dealers[i]

        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end
    end

    for i=1,#roulettePos do
        local posHeading = roulettePos[i]

        local pos = posHeading.xyz
        local heading = posHeading.w

        pos = pos + vector3(
            (dealerOffset.x*math.cos(math.rad(heading))) - (dealerOffset.y*math.sin(math.rad(heading))),
            (dealerOffset.x*math.sin(math.rad(heading))) + (dealerOffset.y*math.cos(math.rad(heading))),
            dealerOffset.z
        )

        if heading < 0 then
            heading = heading + 360.0
        end

        heading = heading - 180.0
        
        if heading < 0 then
            heading = heading + 360.0
        end

        local ped = CreatePed(26, dealers[1], pos, heading, false, true)
        SetEntityCanBeDamaged(ped, false)
        SetPedAsEnemy(ped, false)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedResetFlag(ped, 249, true)
        SetPedConfigFlag(ped, 185, true)
        SetPedConfigFlag(ped, 108, true)
        Citizen.InvokeNative(0x352E2B5CF420BF3B, ped, 1)
        SetPedCanEvasiveDive(ped, false)
        Citizen.InvokeNative(0x2F3C3D9F50681DE4, ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetPedConfigFlag(ped, 208, true)
        SetEntityAsMissionEntity(ped, true, false)
    end
end

function CreateRoulette()
    for i=1,#rouletteProp do
        local hash = rouletteProp[i]

        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end
    end

    for i=1,#roulettePos do
        local posHeading = roulettePos[i]

        local pos = posHeading.xyz
        local heading = posHeading.w

        if heading < 0 then
            heading = heading + 360.0
        end

        local roulette = CreateObjectNoOffset(rouletteProp[1], pos, false, false, false)
        SetEntityHeading(roulette, heading)
    end

end


RegisterCommand('roulette', function(source, args, rawCommand)

end, false)



--- Copied functions
function func_4510(iParam0, iParam1)
	local fVar0 = 0.0;
	local fVar1 = 0.0;
	local fVar2 = 0.0;
	if iParam1 == 0 and iParam0 >= 2 then
		fVar2 =  ((0.083013 * 3.0) * 0.5)
	elseif iParam0 == 0 or iParam0 == 1 then
		fVar2 =  0.074
	else
		fVar2 =  0.083013
	end

	local fVar3 = 0.0;
	if iParam1 == 0 and iParam0 >= 2 and iParam0 ~= 3 then
		fVar3 = 0.1
	elseif iParam0 == 0 then
		fVar3 = (0.081287 * 2.0)
	elseif iParam0 == 1 then
		fVar3 = (0.081287 * 4.0)
	else
		fVar3 = 0.081287
	end
	fVar0 = (iParam0 * fVar2)
	fVar1 = (iParam1 * fVar3)
	fVar0 = (fVar0 + (fVar2 * 0.5))
	fVar1 = (fVar1 + (fVar3 * 0.5))
	return vector3(fVar1, fVar0, 0.0)
end

function func_4518(iParam0, iParam1)
	local fVar0 = 0.0
	local fVar1 = 0.0
	local fVar2 = 0.0
	if iParam1 == 0 and iParam0 >= 2 then
		fVar2 =  ((0.083013 * 3) * 0.5)
	elseif iParam0 == 0 or iParam0 == 1 then
		fVar2 =  0.074
	else
		fVar2 =  0.083013
	end

	local fVar3 = 0.0
	if iParam1 == 0 and iParam0 >= 2 and iParam0 ~= 3 then
		fVar3 = 0.1
	elseif iParam0 == 0 then
		fVar3 = (0.081287 * 2.0)
	elseif iParam0 == 1 then
		fVar3 = (0.081287 * 4.0)
	else
		fVar3 = 0.081287
	end

	local iVar4 = (iParam0 - 2)
	fVar0 = ((iVar4 * fVar2) + (2.0 * 0.074))
	fVar1 = (iParam1 * fVar3)
	fVar1 = (fVar1 * 0.5)
	if iParam1 ~= 25 then
		fVar1 = (fVar1 - (fVar3 * 0.5))
		if iParam1 == 0 then
			fVar0 = (fVar0 + fVar2)
		end
	else
		local iVar5 = (iParam0 - 3)
		fVar0 = (fVar0 + (fVar2 * iVar5))
	end
	return vector3(fVar1, fVar0, 0.0)
end