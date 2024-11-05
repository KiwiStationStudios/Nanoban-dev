local Router = {}
Router.__index = Router

local function _new(_path)
    local self = setmetatable({}, Router)
    self.data = json.decode(love.filesystem.read(_path))

    return self
end

function Router:update()
    
end

return setmetatable(Router, { __call = function(_, ...) return _new(...) end })