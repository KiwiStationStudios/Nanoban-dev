return function(w, h)
    w = w or love.graphics.getWidth()
    h = h or love.graphics.getHeight()
    for y = 0, h * 32, 32 do
        for x = 0, w * 32, 32 do
            love.graphics.setColor(1, 1, 1, 0.5)
                love.graphics.points(x, y)
                --love.graphics.rectangle("line", x, y, 32, 32)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end