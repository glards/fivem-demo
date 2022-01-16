
local reelStartPos = 15

SlotMachine = { }

function SlotMachine:new(id, pos, seatPos, type, reelHash)
    local o = {id = id, pos = pos, seatPos = seatPos, type = type, reelHash = reelHash}
    setmetatable(o, self)
    self.__index = self
    o.reels = {}
    
    local slotOffsets = {
        vector3(-0.115, 0.047, 0.906),
        vector3(0.005, 0.047, 0.906),
        vector3(0.125, 0.047, 0.906)
    }
    
    for j=1,3 do
        local reelPos = GetObjectOffsetFromCoords(o.pos, slotOffsets[j])
        local reel = {
            object = nil,
            pos = reelPos,
            heading = o.pos.w,
            angle = reelStartPos * 22.5,
            nextAnim = 0,
            endPos = nil,
            spinning = false
        }
        table.insert(o.reels, reel)
    end

    o.occupied = false
    o.spinning = false

    return o
end

function SlotMachine:createObjects()
    if self.objectCreated then
        return
    end

    for _, reel in pairs(self.reels) do
        local o = CreateObject(self.reelHash, reel.pos, false, false, true)
        FreezeEntityPosition(o, true)
        SetEntityCollision(o, false, false)
        SetEntityRotation(o, reel.angle, 0.0, reel.heading, 2, true)
        reel.object = o
    end

    self.objectCreated = true
end

function SlotMachine:startSpinning()
    self.spinning = true
    self.fixing = 1
    for i, reel in pairs(self.reels) do
        reel.endPos = nil
        reel.spinning = true
    end

    local soundRef = soundsRef[self.type]
    local sound = sounds[7]

    print("Playing sound", sound, soundRef, self.pos)
    PlaySoundFromCoord(-1, sound, self.pos.x, self.pos.y, self.pos.z, soundRef, true, 50.0, false)
end

function SlotMachine:stopSpinning(reel1, reel2, reel3, cb)
    self.reels[1].endPos = reel1
    self.reels[2].endPos = reel2
    self.reels[3].endPos = reel3

    self.fixing = 1

    self.stopCb = cb
end

function clamp(v, min, max)
    local d = max - min

    while v < min do
        v = v + d
    end

    while v > max do
        v = v - d
    end

    return v
end

-- 0.0, 1.0 -> 1.0
-- 359.0, 0.0  -> 1.0
-- 0.0, 359.0 -> 1.0
-- 1.0, 0.0 -> 1.0
function dist(a, b, min, max)
    local d = max - min

    return math.min(
            math.min(
                math.abs((b + d) - a),
                math.abs(b - a)
            ),
            math.abs(b - (a + d))
           )
end

function SlotMachine:animate(gameTimer)
    local DELAY = 16
    local SPEED = 5.0
    local POS_ANGLE = 22.5
  
    for i, reel in pairs(self.reels) do
        if gameTimer > reel.nextAnim and reel.spinning then
            local nextAngle = clamp(reel.angle + SPEED, 0.0, 360.0)

            if reel.endPos and self.fixing == i then
                local reelAngle = reel.endPos * POS_ANGLE
                if dist(reelAngle, nextAngle, 0.0, 360.0) < 6.0 then
                    local offset = (math.random()-0.5)*6.0
                    nextAngle = reelAngle + offset
                    self.fixing = self.fixing + 1
                    reel.spinning = false
                end
            end

            reel.angle = nextAngle
            reel.nextAnim = gameTimer + DELAY
        end

        if self.objectCreated then
            SetEntityRotation(reel.object, reel.angle, 0.0, reel.heading, 2, true)
        end
    end

    local stillSpinning = false
    for i,reel in pairs(self.reels) do
        if reel.spinning then
            stillSpinning = true
        end
    end

    if self.spinning == true and stillSpinning == false and self.stopCb then
        self.stopCb()
    end

    self.spinning = stillSpinning
end

function SlotMachine:destroyObjects()
    if not self.objectCreated then
        return
    end

    for _, reel in pairs(self.reels) do
        DeleteEntity(reel.object)
    end
    self.objectCreated = false
end

function SlotMachine:tick(playerPed, playerPos, gameTimer)
    -- Game checks if player is within 10.0 units of the machine to create/destroy objects
    if #(playerPos - self.pos.xyz) > 10.0 then
        self:destroyObjects()
    else
        self:createObjects()
    end

    if self.spinning then
        self:animate(gameTimer)
    end
end
