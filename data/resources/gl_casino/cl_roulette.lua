
local rouletteProp = {
    `vw_prop_casino_roulette_01`,
    `vw_prop_casino_roulette_01b`
}

local roulettesData = {
    [1] = {
        modelHash = rouletteProp[1],
        pos = vector4(1144.814, 268.2634, -52.8409, -135.0),
        seats = {
            vector4(1144.342773, 269.022430, -52.840900, 314.999969),
            vector4(1143.655518, 268.335205, -52.840900, 314.999969),
            vector4(1143.748901, 267.377502, -52.840900, 44.999958),
            vector4(1144.717041, 267.277527, -52.840900, 135.000000)
        },
    },
    [2] = {
        modelHash = rouletteProp[1],
        pos = vector4(1150.355, 262.7224, -52.8409, 45.0),
        seats = {
            vector4(1150.826172, 261.963379, -52.840900, 134.999985),
            vector4(1151.513428, 262.650604, -52.840900, 134.999985),
            vector4(1151.420044, 263.608307, -52.840900, 224.999985),
            vector4(1150.451904, 263.708282, -52.840900, 315.000031)
        },
    },
    [3] = {
        modelHash = rouletteProp[1],
        pos = vector4(1133.958, 262.1071, -52.0409, 135.0),
        seats = {
            vector4(1134.717041, 262.578339, -52.040901, 224.999985),
            vector4(1134.029785, 263.265564, -52.040901, 224.999985),
            vector4(1133.072144, 263.172180, -52.040901, 314.999969),
            vector4(1132.972168, 262.204041, -52.040901, 45.000015)
        },
    },
    [4] = {
        modelHash = rouletteProp[0],
        pos = vector4(1129.595, 267.2637, -52.0409, -45.0),
        seats = {
            vector4(1128.835938, 266.792450, -52.040901, 44.999954),
            vector4(1129.523193, 266.105225, -52.040901, 44.999954),
            vector4(1130.480835, 266.198608, -52.040901, 134.999939),
            vector4(1130.580811, 267.166748, -52.040901, 225.000000)
        },
    },
    [5] = {
        modelHash = rouletteProp[0],
        pos = vector4(1144.618, 252.2411, -52.0409, -45.0),
        seats = {
            vector4(1143.859009, 251.769852, -52.040901, 44.999954),
            vector4(1144.546265, 251.082626, -52.040901, 44.999954),
            vector4(1145.503906, 251.176010, -52.040901, 134.999939),
            vector4(1145.603882, 252.144119, -52.040901, 225.000000)
        },
    },
    [6] = {
        modelHash = rouletteProp[0],
        pos = vector4(1148.981, 247.0846, -52.0409, 135.0),
        seats = {
            vector4(1149.739990, 247.555847, -52.040901, 224.999985),
            vector4(1149.052734, 248.243073, -52.040901, 224.999985),
            vector4(1148.095093, 248.149689, -52.040901, 314.999969),
            vector4(1147.995117, 247.181580, -52.040901, 45.000015)
        },
    },
}

local dealerOffset = vector3(-0.68, 0.97, 0.0)

local dealersAnimDicts = {
    'anim_casino_b@amb@casino@games@roulette@dealer',
    'anim_casino_b@amb@casino@games@roulette@dealer_female'
}

local tableAnimDict = 'anim_casino_b@amb@casino@games@roulette@table'

local playerAnimDict = 'anim_casino_b@amb@casino@games@roulette@player'

local markerProp = {
    `vw_prop_vw_marker_01a`,
    `vw_prop_vw_marker_02a`
}

local rouletteBallProp = `vw_prop_roulette_ball`

local rouletteDealers = {}

function CreateDealer()
    for k,v in pairs(roulettesData) do
        local posHeading = v.pos

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

        local dealerGenre = 2

        local ped = CreateDealerPed(pos, heading, dealerGenre)
        table.insert(rouletteDealers, ped)

        local dealerDict = dealersAnimDicts[dealerGenre]
        local anim = 'no_more_bets'

        exports.gl_utils:playNetworkSynchronizedScene(ped, dealerDict, anim, pos, vector3(0.0,0.0,heading), false, true, 1.0, 1.0, 5, 16, 1000.0)
    end
end

local rouletteObjects = {}

function CreateRoulette()
    for i=1,#rouletteProp do
        local hash = rouletteProp[i]

        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end
    end

    for k,v in pairs(roulettesData) do
        local posHeading = v.pos

        local pos = posHeading.xyz
        local heading = posHeading.w

        if heading < 0 then
            heading = heading + 360.0
        end

        local roulette = CreateObjectNoOffset(v.modelHash, pos, false, false, false)
        SetEntityHeading(roulette, heading)

        table.insert(rouletteObjects, roulette)
    end

end

local function loadingThread()
    print('Loading roulette')
    exports.gl_utils:loadAnimDicts(dealersAnimDicts)
    exports.gl_utils:loadAnimDicts(tableAnimDict)
    exports.gl_utils:loadAnimDicts(playerAnimDict)

    rouletteDealers = {}
    CreateDealer()

    rouletteObjects = {}
    CreateRoulette()
end

local function playerThread()
    local ped = PlayerPedId()
    
    StartAudioScene("dlc_vw_casino_slot_machines_playing")

    currentState = Roulette_InsideCasino

    while running do
        Citizen.Wait(0)

        local timer = GetGameTimer()
        local coords = GetEntityCoords(ped)

        if currentState then
            currentState(ped, coords, timer)
        end
    end
end

local running = false
local currentState = nil

function startRoulette()
    if running then
        return
    end

    running = true

    loadingThread()
    Citizen.CreateThread(playerThread)
end

local usedRouletteTable = nil

function Roulette_InsideCasino(ped, coords, timer)
    local closestTable = nil
    local closestTableDistance = 3.0

    for tableId, roulette in pairs(roulettesData) do
        local dist = #(coords - roulette.pos.xyz)

        if dist < closestTableDistance then
            closestTableDistance = dist
            closestTable = broulette
        end
    end

    if closestTable then
        exports.gl_utils:drawNotification(string.format("Appuyez sur ~INPUT_ENTER~ pour jouer sur la table de roulette numéro %d", closestTable.id))
    end

    local controlPressed = IsControlJustPressed(0, INPUT_ENTER)
    if controlPressed and closestTable then
        usedRouletteTable = closestTable

        local closestSeatDistance = 3.0
        local closestSeatId = nil
        for seatId, seatPos in pairs(usedRouletteTable.seats) do

            if not usedRouletteTable.seatsOccupied[seatId] then
                local dist = #(coords - seatPos.xyz)
                if dist < closestSeatDistance then
                    closestSeatId = seatId
                    closestSeatDistance = dist
                end
            end
        end

        -- if closestSeatId then
        --     seatIndex = closestSeatId
        --     currentState = Blackjack_WalkAndSit
        --     TriggerServerEvent("gl_casino:bj:playerSitAtTable", usedBlackjackTable.id, seatIndex)
        -- end
    end
end

function stopRoulette()
    for k,v in ipairs(rouletteDealers) do
        DeleteEntity(v)
    end

    for k,v in ipairs(rouletteObjects) do
        DeleteEntity(v)
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