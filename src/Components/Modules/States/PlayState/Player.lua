local Player = {}
Player.__index = Player

local function _new(_x, _y)
    local self = setmetatable({}, Player)
    self.x = _x
    self.y = _y
    self.w = 32
    self.h = 32

    self.sensors = {}

    self.sensors.UP = {}
    self.sensors.UP.x = self.x + 4
    self.sensors.UP.y = self.y - 10
    self.sensors.UP.w = 8
    self.sensors.UP.h = 8

    self.sensors.DOWN = {}
    self.sensors.DOWN.x = self.x
    self.sensors.DOWN.y = self.y + 10
    self.sensors.DOWN.w = 8
    self.sensors.DOWN.h = 8

    self.sensors.LEFT = {}
    self.sensors.LEFT.x = self.x - 10
    self.sensors.LEFT.y = self.y
    self.sensors.LEFT.w = 8
    self.sensors.LEFT.h = 8

    self.sensors.RIGHT = {}
    self.sensors.RIGHT.x = self.x + 10
    self.sensors.RIGHT.y = self.y
    self.sensors.RIGHT.w = 8
    self.sensors.RIGHT.h = 8

    self.isInCooldown = false
    self.canMoveDirection = {
        UP = false,
        DOWN = false,
        RIGHT = false,
        LEFT = false,
    }
    self.cooldown = 0.2
    self.cooldownTimer = 0
    self.timer = 0
    self.direction = "none"
    self.lastDirection = "none"

    return self
end

function Player:draw()
    love.graphics.setHexColor("#ffff00ff")
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setHexColor("#ff0000ff")
end

function Player:drawSensors()
    love.graphics.setHexColor("#ff0000ff")
    love.graphics.rectangle("fill", self.sensors.UP.x, self.sensors.UP.y, self.sensors.UP.w, self.sensors.UP.h)
    love.graphics.setHexColor("#ffff00ff")
    love.graphics.rectangle("fill", self.sensors.DOWN.x, self.sensors.DOWN.y, self.sensors.DOWN.w, self.sensors.DOWN.h)
    love.graphics.setHexColor("#ff00ffff")
    love.graphics.rectangle("fill", self.sensors.LEFT.x, self.sensors.LEFT.y, self.sensors.LEFT.w, self.sensors.LEFT.h)
    love.graphics.setHexColor("#00ffffff")
    love.graphics.rectangle("fill", self.sensors.RIGHT.x, self.sensors.RIGHT.y, self.sensors.RIGHT.w, self.sensors.RIGHT.h)
    love.graphics.setHexColor("#ffffffff")
end


--______________________________________________[ Player gameplay ]_______________________________________________--

function Player:_checkCollisionWalls()
    for _, h in ipairs(mapObjects.collisions) do
        if collision.rectRect(self.sensors.LEFT, h) then
            self.canMoveDirection.LEFT = false
        end
        if collision.rectRect(self.sensors.RIGHT, h) then
            self.canMoveDirection.RIGHT = false
        end
        if collision.rectRect(self.sensors.UP, h) then
            self.canMoveDirection.UP = false
        end
        if collision.rectRect(self.sensors.DOWN, h) then
            self.canMoveDirection.DOWN = false
        end
    end
end

function Player:_checkCollisionBox()
    for _, o in ipairs(mapObjects.objects) do
        if collision.rectRect(self.sensors.LEFT, o) then
            if o.type == "box" then
                self.canMoveDirection.LEFT = false
            end
        end
        if collision.rectRect(self.sensors.RIGHT, o) then
            if o.type == "box" then
                self.canMoveDirection.RIGHT = false
            end
        end
        if collision.rectRect(self.sensors.UP, o) then
            if o.type == "box" then
                self.canMoveDirection.UP = false
            end
        end
        if collision.rectRect(self.sensors.DOWN, o) then
            if o.type == "box" then
                self.canMoveDirection.DOWN = false
            end
        end
    end
end

function Player:_move(k)
    if not self.isInCooldown then
        if k == "a" or k == "left" then
            if self.canMoveDirection.LEFT then
                self.isInCooldown = true
                self.cooldownTimer = self.cooldown
                self.x = self.x - 32
                self.lastDirection = "left"
            end
        end
        if k == "d" or k == "right" then
            if self.canMoveDirection.RIGHT then
                self.isInCooldown = true
                self.cooldownTimer = self.cooldown
                self.x = self.x + 32
                self.lastDirection = "right"
            end
        end
        if k == "w" or k == "up" then
            if self.canMoveDirection.UP then
                self.isInCooldown = true
                self.cooldownTimer = self.cooldown
                self.y = self.y - 32
                self.lastDirection = "up"
            end
        end
        if k == "s" or k == "down" then
            if self.canMoveDirection.DOWN then
                self.isInCooldown = true
                self.cooldownTimer = self.cooldown
                self.y = self.y + 32
                self.lastDirection = "down"
            end
        end
    end
end

function Player:_pushBox(k)
    if k == "e" then
        for _, o in ipairs(mapObjects.objects) do
            if collision.rectRect(self.sensors.LEFT, o) then
                if o.type == "box" then
                    if o.canMoveDirection.LEFT then
                        o.x = o.x - 32
                    end
                end
            end
            if collision.rectRect(self.sensors.RIGHT, o) then
                if o.type == "box" then
                    if o.canMoveDirection.RIGHT then
                        o.x = o.x + 32
                    end
                end
            end
            if collision.rectRect(self.sensors.UP, o) then
                if o.type == "box" then
                    if o.canMoveDirection.UP then
                        o.y = o.y - 32
                    end
                end
            end
            if collision.rectRect(self.sensors.DOWN, o) then
                if o.type == "box" then
                    if o.canMoveDirection.DOWN then
                        o.y = o.y + 32
                    end
                end
            end
        end
    end
end

function Player:update(elapsed)
    self.sensors.UP.x = self.x + (32 / 2) - 4
    self.sensors.UP.y = self.y - (32 / 2) - 4

    self.sensors.DOWN.x = self.x + (32 / 2) - 4
    self.sensors.DOWN.y = self.y + 32 + (32 / 2) - 4

    self.sensors.LEFT.x = self.x - (32 / 2) - 4
    self.sensors.LEFT.y = self.y + (32 / 2) - 4

    self.sensors.RIGHT.x = self.x + 32 + (32 / 2) - 4
    self.sensors.RIGHT.y = self.y + (32 / 2) - 4

    -- sensors collision --
    self.canMoveDirection.LEFT = true
    self.canMoveDirection.RIGHT = true
    self.canMoveDirection.UP = true
    self.canMoveDirection.DOWN = true

    if self.isInCooldown then
        self.cooldownTimer = self.cooldownTimer - elapsed
        if self.cooldownTimer <= 0 then
            self.isInCooldown = false
            self.cooldownTimer = 0
        end
    end

    self:_checkCollisionWalls()
    self:_checkCollisionBox()
end

function Player:keypressed(k)
    self:_pushBox(k)
    self:_move(k)
end

return setmetatable(Player, { __call = function(_, ...) return _new(...) end })