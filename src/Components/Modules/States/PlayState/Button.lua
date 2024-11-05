local Box = {}
Box.__index = Box

local function _new(_x, _y)
    local self = setmetatable({}, Box)
    self.x = _x
    self.y = _y
    self.w = 32
    self.h = 32
    self.holded = false
    self.type = "button"
    return self
end

function Box:draw()
    if self.holded then
        love.graphics.setHexColor("#00ff00ff")
    else
        love.graphics.setHexColor("#ff0000ff")
    end
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setHexColor("#ffffffff")
end

return setmetatable(Box, { __call = function(_, ...) return _new(...) end })