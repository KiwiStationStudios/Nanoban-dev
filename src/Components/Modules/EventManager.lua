local EventManager = {}

local function _getEventFiles(_path)
    local items = love.filesystem.getDirectoryItems(_path)
    for item = 1, #items, 1 do
        local path = _path .. "/" .. items[item]
        if love.filesystem.getInfo(path).type == "directory" then
            if path ~= "preload" then
                _getEventFiles(path)
            end
        end
        if love.filesystem.getInfo(path).type == "file" then
            if path:match("[^.]+$") == "lua" then
                EventManager.events[(path:match("[^/]+$")):gsub(".lua", "")] = require(path:gsub(".lua", ""))
            end
        end
    end
end

EventManager.events = {}

function EventManager.init()
    _getEventFiles()
end

function EventManager.trigger(_code)
    local code = string.split(_code)
    local name = code[1]
    table.remove(code, 1)
    if EventManager.events[name] then
        EventManager.events[name](unpack(code))
    end
end

return EventManager