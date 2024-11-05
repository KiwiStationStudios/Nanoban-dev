local CollisionBlock = {}
CollisionBlock.__index = CollisionBlock

local function _new(_x, _y)
    local self = setmetatable({}, CollisionBlock)
    self.x = _x
    self.y = _y
    self.w = 32
    self.h = 32
    return self
end

function CollisionBlock:draw()
    love.graphics.setHexColor("#ff000066")
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setHexColor("#ffffffff")
end

return setmetatable(CollisionBlock, { __call = function(_, ...) return _new(...) end })