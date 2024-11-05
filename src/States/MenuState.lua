Menustate = {}

function Menustate:init()
    soundThread = require 'src.Components.Modules.Sound.SoundThread'
    f_title = AssetHandler:useFont("oxygene", 50)
    f_text = AssetHandler:useFont("moderndos", 30)
    stringGen = require 'src.Components.Modules.StringGenerator'
end

function Menustate:enter()
    effect = moonshine(moonshine.effects.dmg).chain(moonshine.effects.chromasep)
    colors = {
        {{1, 1, 1}, {0, 0, 0}, {1, 1, 1}, {0, 0, 0}},
        {{0, 0, 0}, {1, 1, 1}, {0, 0, 0}, {1, 1, 1}},
        {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}, {1, 1, 0}},
        {{1, 0, 1}, {1, 0, 0}, {0, 1, 0}, {0, 0, 1}},
    }
    --print(debug.formattable(effect.dmg))
    effect.dmg.palette = colors[2]

    afkSecretTimer = timer.new()
    flashTimer = timer.new()
    startTimer = timer.new()
    doFlash = false
    inverted = false
    flashCount = 0
    winX, winY = love.window.getPosition()
    started = false
    stopMove = false
    textstate = {
        "Press ENTER to begin",
        "Loading..."
    }
    menuCam = camera(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    yShit = love.graphics.getHeight() / 2


    afkSecretTimer:after(25, function()
        if not started then
            doFlash = true
        end
    end)

    flashTimer:every(0.03, function()
        if not started then
            if flashCount < 100 then
                -- the core --
                inverted = not inverted
                -- shader thing --
                effect.dmg.palette = colors[inverted == true and 1 or math.random(2, 4)]
                effect.chromasep.angle = math.rad(flashCount)
                effect.chromasep.radius = math.floor(flashCount * 0.5)
                
                -- change title --
                love.window.setTitle(stringGen(math.random(12, 25)))
    
                -- invoke the bad in the window --
                local l_winX, l_winY = love.window.getPosition()
                love.window.setPosition(math.random(winX - math.floor(flashCount * 0.5), winX + math.floor(flashCount * 0.5)), math.random(winY - math.floor(flashCount * 0.5), winY + math.floor(flashCount * 0.5)))
    
                local sound = soundThread.newTone(math.random(1, 16), 0.3, "square", 0.6, 2, 1)
                if not sound:isPlaying() then
                    sound:setPitch(math.random(0.8, 1.5))
                    sound:play()
                end
            end
    
            -- another shit timer --
            flashCount = flashCount + 1
            if flashCount > 100 then
                love.window.setFullscreen(true)
                love.mouse.setVisible(false)
            end
            if flashCount > 230 then
                doFlash = false
                love.event.quit()
            end
        end
    end)

    startTimer:every(0.15, function()
        yShit = yShit + 10
        if yShit >= love.graphics.getHeight() + love.graphics.getHeight() / 2 then
            stopMove = true
            gamestate.switch(PlayState)
        end
    end)
end

function Menustate:draw()
    love.graphics.setHexColor("#ffffffff")
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    if flashCount < 100 then
        effect(function()
            menuCam:attach()
                love.graphics.setHexColor("#ffffffff")
                love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
                love.graphics.setHexColor("#000000ff")
                love.graphics.printf("NANOBAN", f_title, 0, 100, love.graphics.getWidth(), "center")
                love.graphics.printf(textstate[started == true and 2 or 1], f_text, 0, 300, love.graphics.getWidth(), "center")
                love.graphics.setHexColor("#ffffffff")
            menuCam:detach()
        end)
    end
end

function Menustate:update(elapsed)
    if not started then
        afkSecretTimer:update(elapsed)
        if doFlash then
            flashTimer:update(elapsed)
        end
    end

    if love.keyboard.isDown("return") and not started then
        started = true
    end

    if started and not stopMove then
        startTimer:update(elapsed)
    end
    menuCam:lookAt(love.graphics.getWidth() / 2, yShit)
end

return Menustate