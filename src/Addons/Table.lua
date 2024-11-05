local s, table_new = pcall(require, "table.new")
if not s then function table_new( --[[narray, nhash]]) return {} end end
table.new = table_new

local s, table_clear = pcall(require, "table.clear")
if not s then function table_clear(t) for i in pairs(t) do t[i] = nil end end end
table.clear = table_clear

local table_move = table.move
if not table_move then
    function table_move(a, f, e, t, b)
        b = b or a; for i = f, e do b[i + t - 1] = a[i] end
        return b
    end

    table.move = table_move
end

function table.contains(_table, _value)
    for _, v in ipairs(_table) do
        if v == _value then
            return true
        end
    end
    return false
end

function table.find(t, val)
    for i = 1, #t do 
        if t[i] == val then 
            return i 
        end 
    end
end

function table.delete(t, obj)
    local index = table.find(t, obj)
    if index then
        table.remove(t, index)
        return true
    end
    return false
end

function table.shuffle(t)
    local l, j = #t
    for i = l, 2, -1 do
        j = math_random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function table.keys(t, includeIndices, keys)
    keys = keys or table.new(#t, 0)
    for i in (includeIndices and pairs or ipairs)(t) do table_insert(keys, i) end
    return keys
end


function table.merge(a, b)
    if a and b then
        for i, v in pairs(b) do a[i] = v end
    end
end

function table.splice(t, start, count, ...)
    local n, removed = #t + 1, {...};
    local c = #removed; start = (start < 1 and n + start or start) + c;
    for i = c, 1, -1 do table.insert(t, start, table.remove(removed, i)) end
    for i = 1, math.min(count or 0, n - start) do
        table.insert(removed, table.remove(t, start))
    end
    return removed
end

return table