return function()
    slab.BeginWindow("tileWindow", {Title = "Tile select", AllowResize = true})
        --slab.BeginListBox("tileWindowListBox", {StretchW = false, StretchH = false})
            for t, quad in ipairs(tileset_data.frames) do
                slab.Image("tileDisplay" .. t, {
                    Image = tileset_sheet,
                    SubX = quad.frame.x,
                    SubY = quad.frame.y,
                    SubW = quad.frame.w,
                    SubH = quad.frame.h,
                    W = 32,
                    H = 32,
                    Color = currentTile == t and {106 / 255, 62 / 255, 135 / 255} or {1, 1, 1},
                    UseOutline = currentTile == t,
                    OutlineColor = currentTile == t and {187 / 255, 119 / 255, 232 / 255} or nil,
                    OutlineW = currentTile == t and 4 or 1
                })
                if t % 14 ~= 0 then
                    slab.SameLine()
                end
                if slab.IsControlClicked() then
                    currentTile = t
                end
            end
        --slab.EndListBox()
    slab.EndWindow()
end