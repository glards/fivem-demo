
local dealerAnim = {
    'idle',
    'female_idle'
}

local dealerSharedDict = 'anim_casino_b@amb@casino@games@shared@dealer@'
local dealerBlackjackDict = 'anim_casino_b@amb@casino@games@blackjack@dealer'

local dealerAnims = {
    DealCardSelf = {
        dict = dealerBlackjackDict,
        anims = {
            'deal_card_self',
            'female_deal_card_self'
        }
    },
    DealCardSelf2 = {
        dict = dealerBlackjackDict,
        anims = {
            'deal_card_self_second_card',
            'female_deal_card_self_second_card'
        }
    },
    DealCardPalyer1 = {
        dict = dealerBlackjackDict,
        anims = {
            'deal_card_player_01',
            'female_deal_card_player_01'
        }
    },
    DealCardPalyer2 = {
        dict = dealerBlackjackDict,
        anims = {
            'deal_card_player_02',
            'female_deal_card_player_02'
        }
    },
    DealCardPalyer3 = {
        dict = dealerBlackjackDict,
        anims = {
            'deal_card_player_03',
            'female_deal_card_player_03'
        }
    },
    DealCardPalyer4 = {
        dict = dealerBlackjackDict,
        anims = {
            'deal_card_player_04',
            'female_deal_card_player_04'
        }
    }
}

local AnimEvents = {
    ATTACH_CARD = -1345695206,
    DETACH_CARD = 585557868
}

local shufflerOffset = vector3(0.526, 0.571, 0.963)
local shufflerRot = vector3(0.0, 164.52, 11.5)

local dealerCardOffset = {
    vector4(0.0356, 0.2105, 0.94885, 178.92),
    vector4(-0.0436, 0.21205, 0.948875, -180.0),
    vector4(-0.0636, 0.213825, 0.9496, -178.92),
    vector4(-0.0806, 0.2137, 0.950225, -177.12),
    vector4(-0.1006, 0.21125, 0.950875, 180.0),
    vector4(-0.1256, 0.21505, 0.951875, 178.56),
    vector4(-0.1416, 0.21305, 0.953, 180.0),
    vector4(-0.1656, 0.21205, 0.954025, 178.2),
    vector4(-0.1836, 0.21255, 0.95495, -177.12),
    vector4(-0.2076, 0.21105, 0.956025, 180.0),
    vector4(-0.2246, 0.21305, 0.957, 178.56)
}

local cardsOffset = {
    [1] = {
        vector4(0.5737, 0.2376, 0.948025, 69.12),
        vector4(0.562975, 0.2523, 0.94875, 67.8),
        vector4(0.553875, 0.266325, 0.94955, 66.6),
        vector4(0.5459, 0.282075, 0.9501, 70.44),
        vector4(0.536125, 0.29645, 0.95085, 70.84),
        vector4(0.524975, 0.30975, 0.9516, 67.88),
        vector4(0.515775, 0.325325, 0.95235, 69.56)
    },
    [2] = {
        vector4(0.2325, -0.1082, 0.94805, 22.11),
        vector4(0.23645, -0.0918, 0.949, 22.32),
        vector4(0.2401, -0.074475, 0.950225, 20.8),
        vector4(0.244625, -0.057675, 0.951125, 19.8),
        vector4(0.249675, -0.041475, 0.95205, 19.44),
        vector4(0.257575, -0.0256, 0.9532, 26.28),
        vector4(0.2601, -0.008175, 0.954375, 22.68)
    },
    [3] = {
        vector4(-0.2359, -0.1091, 0.9483, -21.43),
        vector4(-0.221025, -0.100675, 0.949, -20.16),
        vector4(-0.20625, -0.092875, 0.949725, -16.92),
        vector4(-0.193225, -0.07985, 0.950325, -23.4),
        vector4(-0.1776, -0.072, 0.951025, -21.24),
        vector4(-0.165, -0.060025, 0.951825, -23.76),
        vector4(-0.14895, -0.05155, 0.95255, -19.44)
    },
    [4] = {
        vector4(-0.5765, 0.2229, 0.9482, -67.03),
        vector4(-0.558925, 0.2197, 0.949175, -69.12),
        vector4(-0.5425, 0.213025, 0.9499, -64.44),
        vector4(-0.525925, 0.21105, 0.95095, -67.68),
        vector4(-0.509475, 0.20535, 0.9519, -63.72),
        vector4(-0.491775, 0.204075, 0.952825, -68.4),
        vector4(-0.4752, 0.197525, 0.9543, -64.44)
    },
}

BlackjackTable = {}

BlackjackTable.STATES = {
    IDLE = 1 ,
    DEAL = 2,
    BET = 3
}

function BlackjackTable:New(id, data)
    local o = {
        id = id,
        running = false,
        state = BlackjackTable.STATES.IDLE,
        seatsOccupied = {
            false, false, false, false
        }
    }

    for k,v in pairs(data) do
        o[k] = v
    end

    setmetatable(o, self)
    self.__index = self

    o:createDealer()

    return o
end

function BlackjackTable:createDealer()
    local pos = self.pos.xyz
    local heading = self.pos.w
    local dealerType = self.id + 7
    
    -- Coordinate from decompiled script put peds in the table so we rotate it
    heading = heading-180.0
    if heading < 0.0 then
        heading = heading + 360.0
    end
    --  and move it a bit backward
    local rad = math.rad(heading)
    local backward = vector3(-math.sin(rad), math.cos(rad), 0.0)
    pos = pos - 0.85*backward
    
    self.dealerPed = CreateDealerPed(pos, heading, dealerType)
    self.dealerPos = pos
    self.dealerRot = vector3(0.0, 0.0, heading)
    self.dealerGenre = 1

    if dealerType >= 7 then
        self.dealerGenre = 2
    end
end

-- Code to get the location
-- local obj = GetClosestObjectOfType(pos, 1.0, v.modelHash, false, false, false)
-- if DoesEntityExist(obj) and DoesEntityHaveDrawable(obj) then
--     print("Found table object !")

--     local bones = {
--         GetEntityBoneIndexByName(obj, 'Chair_Base_01'),
--         GetEntityBoneIndexByName(obj, 'Chair_Base_02'),
--         GetEntityBoneIndexByName(obj, 'Chair_Base_03'),
--         GetEntityBoneIndexByName(obj, 'Chair_Base_04'),
--     }

--     for k,v in ipairs(bones) do
--         if v == -1 then
--             print("Bones not found ".. k)
--         else
--             local seatPos = GetWorldPositionOfEntityBone(obj, v)
--             local seatRot = GetEntityBoneRotation(obj, v)

--             local rot = seatRot.z
--             if rot < 0.0 then
--                 rot = rot + 360.0
--             end
--             local seatVector = vector4(seatPos.xyz, rot)
--             print("Seat ".. k .. " : ".. seatVector)
--         end
--     end
-- else
--     print("Object not found")
-- end

function BlackjackTable:dealCards(dealResult)
    local cardPerSeat = {}

    for k,v in pairs(dealResult) do
        local cardIdx = cardPerSeat[v.seatId] or 1
        self:dealCard(v.seatId, cardIdx, v.card)
        cardPerSeat[v.seatId] = cardIdx + 1
    end
end

function BlackjackTable:dealerAnim(animData, cb)
    assert(animData)
    assert(animData.dict)

    local dict = animData.dict
    local anim = animData.anims[self.dealerGenre]

    local animDone = false
    local p = exports.gl_utils:playAnim(self.dealerPed, dict, anim, 2)
    p:next(function(...) animDone = true end)

    while not animDone do
        Citizen.Wait(0)
        cb(self.dealerPed, dict, anim)
    end
end

function BlackjackTable:dealCard(seatId, cardIdx, card)
    assert(seatId >= 0 and seatId <= 4)
    assert(cardIdx >= 1 and cardIdx <= 2)

    local animMap = {
        [1] = dealerAnims.DealCardPalyer1,
        [2] = dealerAnims.DealCardPalyer2,
        [3] = dealerAnims.DealCardPalyer3,
        [4] = dealerAnims.DealCardPalyer4
    }

    local cardFace = vector3(0.0, 0.0, 0.0)
    local anim = nil
    local offset = nil
    if seatId == 0 then
        offset = dealerCardOffset[cardIdx]
        if cardIdx == 1 then
            anim = dealerAnims.DealCardSelf
            cardFace = vector3(0.0, 180.0, 0.0)
        else
            anim = dealerAnims.DealCardSelf2
        end
    else
        offset = cardsOffset[seatId][cardIdx]
        anim = animMap[seatId]
    end

    local cardShufflerPos = GetObjectOffsetFromCoords(self.pos.xyz, self.pos.w, shufflerOffset)

    local cardPos = GetObjectOffsetFromCoords(self.pos.xyz, self.pos.w, offset.xyz)
    local cardRot = vector3(0.0, 0.0, self.pos.w) + vector3(0.0, 0.0, offset.w) + cardFace

    local cardModel = cardHash(card)

    local cardEntity = CreateObjectNoOffset(cardModel, cardShufflerPos, false, false, true)
    SetEntityRotation(cardEntity, shufflerRot, 2, true)

    local attached = false
    local detached = false
    self:dealerAnim(anim, function (ped, dict, anim)
        if HasAnimEventFired(ped, AnimEvents.ATTACH_CARD) and not attached then
            AttachEntityToEntity(cardEntity, ped, GetPedBoneIndex(ped, 28422), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), false, false, false, true, 2, true)
            attached = true
        elseif HasAnimEventFired(ped, AnimEvents.DETACH_CARD) and not detached then
            detached = true
            DetachEntity(cardEntity, false, true)
            SetEntityCoordsNoOffset(cardEntity, cardPos, false, false, true)
            SetEntityRotation(cardEntity, cardRot, 2, true)
        end
    end)
end

function BlackjackTable:dispose()
    DeleteEntity(self.dealerPed)

    self.dealerPed = nil
    self.dealerPos = nil
    self.dealerGenre = nil
end

-- -- Dealer cards
-- do
--     local offset = dealerCardOffset[1]
--     local card = cards[math.random(1, #cards)]
--     local cardPos = GetObjectOffsetFromCoords(v.pos.xyz, v.pos.w, offset.xyz)
--     local cardEntity = CreateObjectNoOffset(card, cardPos, false, false, true)
--     SetEntityRotation(cardEntity, vector3(0.0, 0.0, v.pos.w) + vector3(0.0, 0.0, offset.w), 2, true)
-- end
-- do
--     local offset = dealerCardOffset[2]
--     local card = cards[math.random(1, #cards)]
--     local cardPos = GetObjectOffsetFromCoords(v.pos.xyz, v.pos.w, offset.xyz)
--     local cardEntity = CreateObjectNoOffset(card, cardPos, false, false, true)
--     SetEntityRotation(cardEntity, vector3(0.0, 0.0, v.pos.w) + vector3(0.0, 0.0, offset.w), 2, true)
-- end

-- -- Cards on table
-- for _, cardOffset in pairs(cardsOffset) do
--     for _, offset in pairs(cardOffset) do
--         local card = cards[math.random(1, #cards)]
--         local cardPos = GetObjectOffsetFromCoords(v.pos.xyz, v.pos.w, offset.xyz)
--         local cardEntity = CreateObjectNoOffset(card, cardPos, false, false, true)
--         SetEntityRotation(cardEntity, vector3(0.0, 0.0, v.pos.w) + vector3(0.0, 0.0, offset.w), 2, true)
--     end
-- end

-- do
--     local offset = vector4(0.0, 0.0, 1.0, 0.0)
--     local card = cards[math.random(1, #cards)]
--     local cardPos = GetObjectOffsetFromCoords(v.pos.xyz, v.pos.w, offset.xyz)
--     local cardEntity = CreateObjectNoOffset(card, cardPos, false, false, true)
--     SetEntityRotation(cardEntity, vector3(0.0, 0.0, v.pos.w) + vector3(0.0, 0.0, offset.w), 2, true)
-- end

-- do
--     local offset = vector4(1.0, 0.0, 1.0, 0.0)
--     local card = cards[math.random(1, #cards)]
--     local cardPos = GetObjectOffsetFromCoords(v.pos.xyz, v.pos.w, offset.xyz)
--     local cardEntity = CreateObjectNoOffset(card, cardPos, false, false, true)
--     SetEntityRotation(cardEntity, vector3(0.0, 0.0, v.pos.w) + vector3(0.0, 0.0, offset.w), 2, true)
-- end
