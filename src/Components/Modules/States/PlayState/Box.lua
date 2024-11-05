local Box = {}
Box.__index = Box

local function _new(_x, _y)
    local self = setmetatable({}, Box)
    self.x = _x
    self.y = _y
    self.w = 32
    self.h = 32
    self.type = "box"

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

    self.canMoveDirection = {
        UP = false,
        DOWN = false,
        RIGHT = false,
        LEFT = false,
    }
    return self
end

function Box:draw()
    love.graphics.print(string.format("%s|%s", self.x, self.y), 5, 90)

    love.graphics.setHexColor("#ff0000ff")
    love.graphics.rectangle("fill", self.sensors.UP.x, self.sensors.UP.y, self.sensors.UP.w, self.sensors.UP.h)
    love.graphics.setHexColor("#ffff00ff")
    love.graphics.rectangle("fill", self.sensors.DOWN.x, self.sensors.DOWN.y, self.sensors.DOWN.w, self.sensors.DOWN.h)
    love.graphics.setHexColor("#ff00ffff")
    love.graphics.rectangle("fill", self.sensors.LEFT.x, self.sensors.LEFT.y, self.sensors.LEFT.w, self.sensors.LEFT.h)
    love.graphics.setHexColor("#00ffffff")
    love.graphics.rectangle("fill", self.sensors.RIGHT.x, self.sensors.RIGHT.y, self.sensors.RIGHT.w, self.sensors.RIGHT.h)
    love.graphics.setHexColor("#ffffffff")
    
    love.graphics.setHexColor("#ff007cff")
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setHexColor("#ffffffff")
end

function Box:update(elapsed)
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

    for _, o in ipairs(mapObjects.objects) do
        if o.type == "box" then
            if collision.rectRect(self.sensors.LEFT, o) then
                self.canMoveDirection.LEFT = false
            end
            if collision.rectRect(self.sensors.RIGHT, o) then
                self.canMoveDirection.RIGHT = false
            end
            if collision.rectRect(self.sensors.UP, o) then
                self.canMoveDirection.UP = false
            end
            if collision.rectRect(self.sensors.DOWN, o) then
                self.canMoveDirection.DOWN = false
            end
        end
    end
end

return setmetatable(Box, { __call = function(_, ...) return _new(...) end })