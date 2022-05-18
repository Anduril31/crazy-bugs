
menu = {}

local fontTitle = nil 
local tweening = {}

menu.load = function()
    if (APP_DEBUG) then
        print("Scene menu.load()")
    end
    -- Chargement des ressources communes
    fontTitle = love.graphics.newFont( 'Fonts/emulogic.ttf', 24)
    fontDefault = love.graphics.newFont( 'Fonts/emulogic.ttf', 12)
    fontDebug = love.graphics.newFont( 'Fonts/emulogic.ttf', 9)
    


    menu.initTween()
end

menu.initTween = function()
    tweening[1] = {}
    tweening[1].time = 0
    tweening[1].value = -50
    tweening[1].distance = 170
    tweening[1].duration = 0.5

    tweening[2] = {}
    tweening[2].time = 0
    tweening[2].value = -150
    tweening[2].distance = 510
    tweening[2].duration = 0.5
end

menu.unload = function()
    if (APP_DEBUG) then
        print("Scene menu.unload()")
    end
end

menu.update = function(dt)
    if tweening[1].time < tweening[1].duration then
        tweening[1].time = tweening[1].time + dt
    elseif tweening[2].time < tweening[2].duration then
        tweening[2].time = tweening[2].time + dt
    end
end

menu.draw = function()
    local tween
    tween = EffectManager.easeOutSin(tweening[1].time, tweening[1].value, tweening[1].distance, tweening[1].duration)
    tween2 = EffectManager.easeOutSin(tweening[2].time, tweening[2].value, tweening[2].distance, tweening[2].duration)

    --love.graphics.setColor(252, 227, 0)
    love.graphics.setFont(fontTitle)

    local sTitre = "Titre du jeu"
    local w = fontTitle:getWidth(sTitre)
    -- local h = fontTitle:getHeight(sTitre)
    love.graphics.print(sTitre, (love.graphics.getWidth() - w) / 2, tween)
    love.graphics.rectangle('fill', (love.graphics.getWidth() - w) / 2, 150, w, 25)
    
    if tweening[1].time > tweening[1].duration then
        love.graphics.setFont(fontDefault)
        love.graphics.print("(P)   Play", tween2, 230)
        love.graphics.print("(ESC) Quit", tween2, 250)
    end
end

menu.keypressed = function(key)
    -- P pour lancer la partie
    if (key == 'p') then
        SceneManager.switch('poc_controller')
    end
    if (key == 'escape') then
        love.event.quit()
    end
end


return menu
