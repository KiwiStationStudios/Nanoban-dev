return function()
    local tools = {
        [0] = "pencil",
        [1] = "fill",
        [2] = "eraser",
    }
    slab.BeginWindow("layerWindow", { Title = "Layer select", AllowResize = false })
        if slab.Button("Add layer") then
            
        end
        slab.BeginListBox("layerWindowListBox")
            for i = 1, #levelData.layers, 1 do
                slab.BeginListBoxItem('layerWindowListBoxItem' .. i, {Selected = currentLayer == i})
                    slab.Text(levelData.layers[i].name)
                    if slab.IsListBoxItemClicked() then
                        currentLayer = i
                    end
                slab.EndListBoxItem()
            end
        slab.EndListBox()
        slab.Separator()
        if slab.Button(levelData.layers[currentLayer].visible and "Visible: ON" or "Visible: OFF") then
            levelData.layers[currentLayer].visible = not levelData.layers[currentLayer].visible
        end
        slab.SameLine()
        if slab.Button(levelData.layers[currentLayer].locked and "Locked: ON" or "Locked: OFF") then
            levelData.layers[currentLayer].locked = not levelData.layers[currentLayer].locked
        end
        slab.Separator()
        slab.Text("Tools")
        for b = 0, 2, 1 do
            slab.Image("buttonTool" .. b, {
                Image = buttons_sheet,
                SubX = buttons_data.frames["btn" .. b].frame.x,
                SubY = buttons_data.frames["btn" .. b].frame.y,
                SubW = buttons_data.frames["btn" .. b].frame.w,
                SubH = buttons_data.frames["btn" .. b].frame.h,
                W = 32,
                H = 32,
                ReturnOnClick = true,
            })
            if slab.IsControlClicked() then
                if b >= 1 then
                    currentMode = "erase"
                else
                    currentMode = "add"
                end
                currentTool = tools[b]
            end
            slab.SameLine()
        end
        slab.NewLine(3)
        slab.Text("Current tool: " .. currentTool)
        --slab.Text("Current mode: " .. (currentMode == "add" and "paint" or "erase"))
    slab.EndWindow()
end