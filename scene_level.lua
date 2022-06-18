
scene_level = {}

local imgBackground = {}
local imgTitle = {}
local SnailManager = require('SnailManager')
local snail = nil;

scene_level.load = function()
    if (APP_DEBUG) then
        print("Scene scene_level.load()")
    end

    -- Récupère le niveau maxi du joueur
    file = love.filesystem.newFile("save.cb")
    file:open("r")
    data = file:read()
    file:close()
    if (tonumber(data) == nil or tonumber(data) == 0) then
        currentDefi = 1
    else
        currentDefi = tonumber(data)
    end

    -- Background
    imgBackground.img = love.graphics.newImage("Images/background2.png")
    -- Titre
    imgTitle.img = love.graphics.newImage("Images/title.png")
    -- Escargot
    snail = SnailManager.createSnail(60, 565, 70, 250)

    -- UI
    grpScLevel = Gui.newGroup()
    panelLevel = Gui.newPanel(
        (love.graphics.getWidth()/SCALE - 510)/2,
        (love.graphics.getHeight()/SCALE -260)/2,
        510, 320,
        {48, 48, 48, 0.8}
    )
    grpScLevel:addElement(panelLevel)
    local color = Utils.ColorFromRgb(87, 168, 50)
    
    btnBack = Gui.newButton(
        (panelLevel.X + panelLevel.W +100)/2,
        panelLevel.Y + panelLevel.H - 50, 
        100, 40, 
        "Back", 
        fontDefault,
        {247, 247, 216},
        {color['r'], color['g'], color['b']}
    )
    btnBack:setEvent("pressed", scene_level.onButtonPressedBack)
    grpScLevel:addElement(btnBack)

    l = 1
    c = 1
    for i = 1, currentDefi do
        if c > 10 then 
            l = l+1 
            c = 1
        end

        btnLevel = Gui.newButton(
            panelLevel.X + 10 + (c-1)*50,
            panelLevel.Y + 10 + (l-1)*50, 
            40, 40, 
            tostring(i), 
            fontDefault,
            {247, 247, 216},
            {color['r'], color['g'], color['b']},
            { level = i}
        )
        c = c+1
        btnLevel:setEvent("pressed", scene_level.onButtonPressedChoiceLevel)
        grpScLevel:addElement(btnLevel)
    end
end

scene_level.onButtonPressedBack = function(pState)
    SceneManager.switch('menu')
end

scene_level.onButtonPressedChoiceLevel = function(pState, data)
    
    if type(data) == 'table' then
        LevelChoice = data.level
        SceneManager.switch('game')
    end
end

scene_level.unload = function()
    if (APP_DEBUG) then
        print("Scene scene_level.unload()")
    end
end

scene_level.update = function(dt)
    snail.update(dt)
    grpScLevel:update(dt)
end

scene_level.draw = function()
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
   
    -- Affichage de l'escargot
    snail.draw()

    grpScLevel:draw()
end

scene_level.keypressed = function(key)
    -- P pour lancer la partie
    if (key == 'enter') then
        LevelChoice = scene_level.levelChoice
        SceneManager.switch('game')
    end
    if (key == 'r') then
        SceneManager.switch('menu')
    end
end


return scene_level
