local createMap = require 'src.Components.Modules.States.EditorState.CreateMap'

return function()
    slab.BeginWindow("mapManagerWindow", { Title = "Map Manager", AllowResize = false })
        if registers.states.editorState.tempWindow.managerState == "create" then
            slab.Text("map name:")
            slab.SameLine()
            if slab.Input("mapManagerCreateMapNameInput", { Text = registers.states.editorState.tempWindow.inputs.mapName }) then
                registers.states.editorState.tempWindow.inputs.mapName = slab.GetInputText()
            end
            slab.Text("map width (in tiles):")
            slab.SameLine()
            if slab.Input("mapManagerCreateMapWidthInput", { Text = registers.states.editorState.tempWindow.inputs.mapWidth }) then
                registers.states.editorState.tempWindow.inputs.mapWidth = slab.GetInputNumber()
            end
            slab.SameLine()
            slab.Text("map height (in tiles):")
            slab.SameLine()
            if slab.Input("mapManagerCreateMapHeightInput", { Text = registers.states.editorState.tempWindow.inputs.mapHeight }) then
                registers.states.editorState.tempWindow.inputs.mapHeight = slab.GetInputNumber()
            end
            slab.Text("Map size (in pixels) : " .. registers.states.editorState.tempWindow.inputs.mapWidth * 32 .. "x" .. registers.states.editorState.tempWindow.inputs.mapHeight * 32)
        elseif registers.states.editorState.tempWindow.managerState == "open" then

        end
        if slab.Button("Cancel") then
            registers.states.editorState.tempWindow.managerWindowOpen = false
        end
        slab.SameLine()
        if registers.states.editorState.tempWindow.managerState == "create" then
            if slab.Button("Open map") then
                registers.states.editorState.tempWindow.managerState = "open"
            end
        elseif registers.states.editorState.tempWindow.managerState == "open" then
            if slab.Button("Create map") then
                registers.states.editorState.tempWindow.managerState = "create"
            end
        end
        slab.SameLine()
        if slab.Button("OK") then
            if registers.states.editorState.tempWindow.managerState == "create" then
                createMap(
                    registers.states.editorState.tempWindow.inputs.mapName, 
                    registers.states.editorState.tempWindow.inputs.mapWidth, 
                    registers.states.editorState.tempWindow.inputs.mapHeight
                )
                registers.states.editorState.mapLoaded = true
                registers.states.editorState.tempWindow.managerWindowOpen = false
            end
        end
    slab.EndWindow()
end