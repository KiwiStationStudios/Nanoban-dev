EditorState = {}

function EditorState:init()
    grid = require 'src.Components.Modules.States.EditorState.Grid'
    layer = require 'src.Components.Modules.States.EditorState.Layer'

    layerWindow = require 'src.Components.Modules.States.EditorState.LayerWindow'
    tileWindow = require 'src.Components.Modules.States.EditorState.TileWindow'

    love.window.setTitle("[DebugEditor] - " ..love.window.getTitle() .. " - " ..VERSION.ENGINE)
    love.window.setMode(1280, 768)

    tileset_sheet, tileset_quads = love.graphics.getQuads("assets/images/tileset")
    tileset_data = json.decode(love.filesystem.read("assets/images/tileset.json"))
    buttons_sheet, buttons_data = love.graphics.newImage("assets/images/buttons.png"), json.decode(love.filesystem.read("assets/images/buttons.json"))
end

function EditorState:enter()
    editorCam = camera()
    editorCam.speed = 5
    editorCam.scrollZoom = 1 
    editorCam.targetZoom = 1
    mouseX, mouseY = 0, 0
    mouseUse = true
    tileX, tileY = 0, 0

    currentLayer = 1
    currentTile = 1
    currentTool = "pencil"
    currentMode = "add"

    levelData = {
        levelID = "default",
        properties = {
            -- counted in tiles 32 * 32 --
            width = 40,
            height = 24,
        },
        layers = {}
    }

    selectionArea = {
        visible = false,
        x = 0,
        y = 0,
        w = 0,
        h = 0,
        normalizedW = 0,
        normalizedH = 0
    }

    -- create default layers --
    table.insert(levelData.layers, layer("blocks", "tile", levelData.properties.width, levelData.properties.height))
    table.insert(levelData.layers, layer("collisionblocks", "collision", levelData.properties.width, levelData.properties.height))
    table.insert(levelData.layers, layer("events", "event", levelData.properties.width, levelData.properties.height))
end

function EditorState:draw()
    editorCam:attach()
        -- render layers --
        for _, l in ipairs(levelData.layers) do
            if l.visible then
                for y = 1, levelData.properties.height, 1 do
                    for x = 1, levelData.properties.width, 1 do
                        local tileID = l.data[y][x]
                        if l.type == "tile" then
                            if tileID ~= 0 then
                                if l.locked then
                                    love.graphics.setColor(0.4, 0.4, 0.4)
                                end
                                love.graphics.draw(tileset_sheet, tileset_quads[tileID], x * 32 - 32, y * 32 - 32)
                                love.graphics.setColor(1, 1, 1)
                            end
                        end
                        if l.type == "collision" then
                            -- connected shit later --
                            if tileID then
                                love.graphics.setColor(1, 1, 1, 0.5)
                                love.graphics.rectangle("fill", x * 32 - 32, y * 32 - 32, 32, 32)
                                love.graphics.setColor(1, 1, 1, 1)
                            end
                        end
                        if l.type == "event" then
                            -- add shit --
                        end
                    end
                end
            end
        end

        -- grid --
        love.graphics.setBlendMode("replace")
            love.graphics.setPointSize(3)
                grid(levelData.properties.width, levelData.properties.height)
            love.graphics.setPointSize(1)
        love.graphics.setBlendMode("alpha")

        -- cursor --
        if mouseUse and not selectionArea.visible then
            love.graphics.setLineWidth(5)
                switch(currentTool, {
                    ["pencil"] = function()
                        love.graphics.setColor(0, 1, 0)
                    end,
                    ["fill"] = function()
                        love.graphics.setColor(242 / 255, 167 / 255, 36 / 255)
                    end,
                    ["eraser"] = function()
                        love.graphics.setColor(1, 0, 0)
                    end
                })
                love.graphics.rectangle("line", mouseX, mouseY, 32, 32)
                love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setLineWidth(1)
        end

        -- map bounds --
        love.graphics.setLineWidth(5)
            love.graphics.rectangle("line", 0, 0, levelData.properties.width * 32, levelData.properties.height * 32)
        love.graphics.setLineWidth(1)
    editorCam:detach()
    slab.Draw()
end

function EditorState:update(elapsed)
    slab.Update(elapsed)

    -- slab interface --
    layerWindow()
    tileWindow()

    -- mouse updates --
    local mx, my = editorCam:mousePosition()
    mouseX = math.floor(mx / 32) * 32
    mouseY = math.floor(my / 32) * 32

    -- check if mouse is in the map bounds --
    -- to not try access a invalid array address --
    mouseUse = mx >= 0 
    and mx <= levelData.properties.width * 32 
    and my >= 0 
    and my <= levelData.properties.height * 32 
    and slab.IsVoidHovered()
    and not slab.IsControlHovered()
    and not slab.IsControlClicked(1)

    selectionArea.visible = (love.mouse.isDown(1) and currentTool == "rectangle")
    
    -- block place --
    if love.mouse.isDown(1) then
        local cx, cy = math.floor(mx / 32) + 1, math.floor(my / 32) + 1
        if mouseUse then
            if levelData.layers[currentLayer].data[cy] and levelData.layers[currentLayer].data[cy][cx] then
                if levelData.layers[currentLayer].visible and not levelData.layers[currentLayer].locked then
                    --levelData.layers[currentLayer].data[cy][cx] = 1
                    switch(currentTool, {
                        ["pencil"] = function()
                            switch(levelData.layers[currentLayer].type, {
                                ["tile"] = function()
                                    levelData.layers[currentLayer].data[cy][cx] = currentTile
                                end,
                                ["collision"] = function()
                                    levelData.layers[currentLayer].data[cy][cx] = true
                                end
                            })
                        end,
                        ["fill"] = function()
                            local function floodFill(grid, startX, startY, targetValue, replaceValue)
                                    -- Check if the starting point is already the replacement color
                                if targetValue == replaceValue then return end

                                -- Queue to store the points to be processed
                                local queue = {}

                                -- Add the starting point to the queue
                                table.insert(queue, {x = startX, y = startY})

                                -- Process each point in the queue
                                while #queue > 0 do
                                    -- Get the current point from the queue
                                    local point = table.remove(queue, 1)
                                    local x, y = point.x, point.y

                                    -- Make sure the point is within bounds and has the target color
                                    if x >= 1 and x <= #grid[1] and y >= 1 and y <= #grid and grid[y][x] == targetValue then
                                        -- Fill the current point with the replacement color
                                        grid[y][x] = replaceValue

                                        -- Add the neighboring points to the queue (left, right, up, down)
                                        table.insert(queue, {x = x - 1, y = y}) -- left
                                        table.insert(queue, {x = x + 1, y = y}) -- right
                                        table.insert(queue, {x = x, y = y - 1}) -- up
                                        table.insert(queue, {x = x, y = y + 1}) -- down
                                    end
                                end
                                lume.clear(queue)
                                collectgarbage("collect")
                            end

                            switch(levelData.layers[currentLayer].type, {
                                ["tile"] = function()
                                    local curTileAtPos = levelData.layers[currentLayer].data[cy][cx]
                                    floodFill(levelData.layers[currentLayer].data, cx, cy, curTileAtPos, currentTile)
                                end,
                                ["collision"] = function()
                                    local curTileAtPos = levelData.layers[currentLayer].data[cy][cx]
                                    floodFill(levelData.layers[currentLayer].data, cx, cy, curTileAtPos, true)
                                end
                            })
                        end,
                        ["eraser"] = function()
                            switch(levelData.layers[currentLayer].type, {
                                ["tile"] = function()
                                    levelData.layers[currentLayer].data[cy][cx] = 0
                                end,
                                ["collision"] = function()
                                    levelData.layers[currentLayer].data[cy][cx] = false
                                end
                            })
                        end
                    })
                end
            end
        end
    end

    -- zoom smooth --
    editorCam.scrollZoom = editorCam.scrollZoom - (editorCam.scrollZoom - editorCam.targetZoom) * 0.05
    editorCam.scale = editorCam.scrollZoom

    -- zoom clamp --
    if editorCam.targetZoom < 0.2 then
        editorCam.targetZoom = 0.2
    end
    if editorCam.targetZoom > 3 then
        editorCam.targetZoom = 3
    end
end

function EditorState:wheelmoved(x, y)
    if y < 0 then
        editorCam.targetZoom = editorCam.targetZoom - 0.05
    end
    if y > 0 then
        editorCam.targetZoom = editorCam.targetZoom + 0.05
    end
end

function EditorState:mousemoved(x, y, dx, dy)
    -- mouse scroll --
    if love.mouse.isDown(3) then
        editorCam.x = editorCam.x - dx / editorCam.scale
        editorCam.y = editorCam.y - dy / editorCam.scale
    end
    if love.mouse.isDown(1) and currentTool == "rectangle" then
        selectionArea.normalizedW = (selectionArea.normalizedW + (dx / editorCam.scale))
        selectionArea.normalizedH = (selectionArea.normalizedH + (dy / editorCam.scale))
        selectionArea.w = math.floor((selectionArea.normalizedW + 32) / 32) * 32
        selectionArea.h = math.floor((selectionArea.normalizedH + 32) / 32) * 32
    end
end

function EditorState:leave()
    love.window.setMode(640, 480)
end

return EditorState