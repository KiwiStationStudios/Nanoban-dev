local Autotile = {}

local function isFilled(map, x, y) return map[y] and map[y][x] == true end

local function getTileID(map, x, y)
    local id = 0
    -- Verifica vizinhos usando um sistema binário (acima, esquerda, direita, abaixo)
    if isFilled(map, x, y - 1) then id = id + 1 end  -- cima
    if isFilled(map, x + 1, y) then id = id + 2 end  -- direita
    if isFilled(map, x, y + 1) then id = id + 4 end  -- baixo
    if isFilled(map, x - 1, y) then id = id + 8 end  -- esquerda

    return id
end

function Autotile.generateLayer(map)
    local tiledLayer = {}
    
end

return Autotile