
menu = {}

local tweening = {}

menu.load = function()
    if (APP_DEBUG) then
        print("Scene menu.load()")
    end


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
    tweening[2].distance = (love.graphics.getWidth()+60/SCALE)/2
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

    local sTitre = "Crazy Bugs"
    local w = fontTitle:getWidth(sTitre)
    love.graphics.print(sTitre, ((love.graphics.getWidth() - w)/SCALE) / 2, tween)
    love.graphics.rectangle('fill', ((love.graphics.getWidth() - w))/SCALE / 2, 160, w, 25)
    
    love.graphics.setFont(fontDebug)
    local sCredit = "Sound Effect by @BurghRecords"
    w = fontDebug:getWidth(sCredit)
    love.graphics.print(sCredit, (love.graphics.getWidth() - w)/SCALE / 2, love.graphics.getHeight()/SCALE - 20)
    
    if tweening[1].time > tweening[1].duration then
        love.graphics.setFont(fontDefault)
        love.graphics.print("(P)   Play", tween2, 230)
        love.graphics.print("(ESC) Quit", tween2, 250)
    end
end

menu.keypressed = function(key)
    -- P pour lancer la partie
    if (key == 'p') then
        SceneManager.switch('game')
    end
    if (key == 'escape') then
        love.event.quit()
    end
end


return menu
