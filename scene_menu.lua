
menu = {}

local tweening = {}
local imgBackground = {}
local imgTitle = {}

menu.load = function()
    if (APP_DEBUG) then
        print("Scene menu.load()")
    end
    -- Background
    imgBackground.img = love.graphics.newImage("Images/background2.png")
    -- Titrel
    imgTitle.img = love.graphics.newImage("Images/title.png")


    grpMenu = Gui.newGroup()
    panelMenu = Gui.newPanel(
        (love.graphics.getWidth()/SCALE - 170)/2  , (love.graphics.getHeight()/SCALE -130)/2,
        170, 130,
        {48, 48, 48, 0.8}
    )
    color = Utils.ColorFromRgb(87, 168, 50)
    btnPlay = Gui.newButton(
        panelMenu.X + 10, panelMenu.Y + 10, 
        150, 28, 
        "PLAY", fontDefault,
        {247, 247, 216},
        {color['r'], color['g'], color['b']}
    )
    btnLevel = Gui.newButton(
        panelMenu.X + 10, panelMenu.Y + 50,
        150, 28, 
        "LEVEL", fontDefault,
        {247, 247, 216},
        {color['r'], color['g'], color['b']}
    )
    btnQuit = Gui.newButton(
        panelMenu.X + 10, panelMenu.Y + 90,
        150, 28, 
        "QUIT", fontDefault,
        {247, 247, 216},
        {color['r'], color['g'], color['b']}
    )
    btnPlay:setEvent("pressed", menu.onButtonPressedPlay)
    btnLevel:setEvent("pressed", menu.onButtonPressedLevel)
    btnQuit:setEvent("pressed", menu.onButtonPressedQuit)
    grpMenu:addElement(panelMenu)
    grpMenu:addElement(btnPlay)
    grpMenu:addElement(btnLevel)
    grpMenu:addElement(btnQuit)

end

menu.onButtonPressedPlay = function(pState)
    GameMode = "NORMAL"
    SceneManager.switch('game')
end

menu.onButtonPressedLevel = function(pState)
    GameMode = "LEVEL"
    SceneManager.switch('level')
end

menu.onButtonPressedQuit = function(pState)
    love.event.quit()
end

menu.unload = function()
    if (APP_DEBUG) then
        print("Scene menu.unload()")
    end
end

menu.update = function(dt)
    grpMenu:update(dt)
end

menu.draw = function()

    local color = Utils.ColorFromRgb(70, 63, 50)
    love.graphics.setBackgroundColor(color.r, color.g, color.b)

    -- Affichage du background
    love.graphics.draw(imgBackground.img, 0, 0)
    
    -- Affichage du titre
    love.graphics.draw(
        imgTitle.img, 
        (love.graphics.getWidth()/SCALE - imgTitle.img:getWidth())/2, 
        20
    )

    -- UI
    grpMenu:draw()

    love.graphics.setFont(fontDebug)
    local sCredit = "Sound Effect by @BurghRecords"
    w = fontDebug:getWidth(sCredit)
    love.graphics.print(sCredit, (love.graphics.getWidth() - w)/SCALE / 2, love.graphics.getHeight()/SCALE - 30)

    local sCredit2 = "Cartoon jungle vector created by brgfx - www.freepik.com"
    w = fontDebug:getWidth(sCredit2)
    love.graphics.print(sCredit2, (love.graphics.getWidth() - w)/SCALE / 2, love.graphics.getHeight()/SCALE - 20)
end

menu.keypressed = function(key)
    if (APP_DEBUG) then
        print("Scene menu.keypressed("..key..")")
        if (key == 'escape') then
            love.event.quit()
        end
    end
    
end


return menu
