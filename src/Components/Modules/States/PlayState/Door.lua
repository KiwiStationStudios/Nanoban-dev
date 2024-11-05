local Door = {}
Door.__index = Door

local function _new(_x, _y)
    local self = setmetatable({}, Door)
    self.x = _x
    self.y = _y
    self.w = 32
    self.h = 64
    self.open = false
    self.type = "door"
    return self
end

function Door:draw()
    love.graphics.setHexColor("#0097ffff")
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setHexColor("#ffffffff")
end

return setmetatable(Door, { __call = function(_, ...) return _new(...) end })