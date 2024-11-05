
function love.system.getDevice()
    local os = love.system.getOS()
    if os == "Android" or os == "iOS" then
        return "Mobile"
    elseif os == "OS X" or os == "Windows" or os == "Linux" then
        return "Desktop"
    end
    return "Unknown"
end

return love.system