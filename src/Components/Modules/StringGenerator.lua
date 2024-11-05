return function(_len)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local text = ""
    for t = 1, _len, 1 do
        local v = math.random(1, #chars)
        text = text .. string.sub(chars, v, v)
    end
    return text
end