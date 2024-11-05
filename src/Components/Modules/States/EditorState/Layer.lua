return function(_layerName, _type, _w, _h)
    local layer = {}
    layer.name = _layerName
    layer.type = _type or "tile"
    layer.visible = true
    layer.locked = false
    layer.data = {}

    switch(_type, {
        ["tile"] =  function()
            for y = 1, _h, 1 do
                layer.data[y] = {}
                for x = 1, _w, 1 do
                    layer.data[y][x] = 0
                end
            end
        end,
        ["collision"] = function()
            for y = 1, _h, 1 do
                layer.data[y] = {}
                for x = 1, _w, 1 do
                    layer.data[y][x] = false
                end
            end
        end,
        ["event"] = function()
            for y = 1, _h, 1 do
                layer.data[y] = {}
                for x = 1, _w, 1 do
                    layer.data[y][x] = {}
                end
            end
        end,
    })

    return layer
end