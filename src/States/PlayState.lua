PlayState = {}

local function _getObjectProperties(_name)
    for _, data in pairs(l_objects) do
        if data.name == _name then
            return data
        end
    end
    return nil
end

local function _getTypeCount(_type)
    local c = 0
    for _, obj in pairs(l_objects) do
        if obj.type == _type then
            c = c + 1
        end
    end
    return c
end

function PlayState:init()
    router = require ('src.Components.Modules.Router')("assets/data/Router.json")

    collisionBlock = require 'src.Components.Modules.States.PlayState.CollisionBlock'
    player = require 'src.Components.Modules.States.PlayState.Player'
    box = require 'src.Components.Modules.States.PlayState.Box'
    button = require 'src.Components.Modules.States.PlayState.Button'
    door = require 'src.Components.Modules.States.PlayState.Door'
end

function PlayState:enter()

    map = sti("assets/data/maps/world.lua")
    mapMeta = cartographer.load("assets/data/maps/world.lua")

    l_collisionMap = mapMeta.layers["collisions"]
    l_objects = mapMeta.layers[2].objects

    mapObjects = {
        collisions = {},
        objects = {}
    }

    for _, gid, _, _, px, py in l_collisionMap:getTiles() do
        table.insert(mapObjects.collisions, collisionBlock(px, py))
    end

    for _, obj in pairs(l_objects) do
        switch(obj.type, {
            ["box"] = function()
                table.insert(mapObjects.objects, box(obj.x, obj.y))
            end,
            ["button"] = function()
                table.insert(mapObjects.objects, button(obj.x, obj.y))
            end,
            ["door"] = function()
                table.insert(mapObjects.objects, door(obj.x, obj.y))
            end
        })
    end

    playerProps = _getObjectProperties("player")
    p = player(l_objects[1].x, l_objects[1].y)
end

function PlayState:draw()
    map:drawTileLayer("tiles")
    for _, b in ipairs(mapObjects.collisions) do
        b:draw()
    end
    for _, b in ipairs(mapObjects.objects) do
        if b.draw then
            b:draw()
        end
    end
    p:draw()
    p:drawSensors()
end

function PlayState:update(elapsed)
    p:update(elapsed)
    for _, b in ipairs(mapObjects.objects) do
        if b.update then
            b:update(elapsed)
        end
    end
end

function PlayState:keypressed(k)
    p:keypressed(k)
end

return PlayState