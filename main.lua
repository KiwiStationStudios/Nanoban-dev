love.filesystem.load("src/Components/Initialization/Run.lua")()
love.filesystem.load("src/Components/Initialization/ErrorHandler.lua")()

AssetHandler = require("src.Components.Helpers.AssetManager")()

VERSION = {
    ENGINE = "0.0.1",
    FORMATS = "0.0.1"
}

function love.initialize(args)
    eventManager = require 'src.Components.Modules.EventManager'
    --eventManager.init()

    slab.Initialize({"NoDocks"})

    curslot = neuron.new("game")
    curslot.save.game = {}

    AssetHandler:init()

    registers = {
        states = {
        }
    }

    local states = love.filesystem.getDirectoryItems("src/States")
    for s = 1, #states, 1 do
        require("src.States." .. states[s]:gsub(".lua", ""))
    end

    if DEBUG_APP then
        love.filesystem.createDirectory("editor")
        love.filesystem.createDirectory("editor/maps")
    end

    gamestate.registerEvents()
    gamestate.switch(EditorState)
end

function love.keypressed(k)
    if DEBUG_APP then
        if k == "f12" then
            gamestate.switch(EditorState)
        end
    end
end