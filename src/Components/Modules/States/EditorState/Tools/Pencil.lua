return function(data, mode, cx, cy)
    switch(currentMode, {
        ["add"] =  function()
            data[cy][cx] = currentTile
        end,
        ["erase"] = function()
            data[cy][cx] = 0
        end
    })
end