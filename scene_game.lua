game = {}

local scene = {}

local mousePosX = 0
local mousePosY = 0

local isMouseOverTuile = false
local isMouseOverCase = false

local Tuile = require("tuile")
local tuileList = {}

local Case = require("case")
local caseList = {}

local imgBeetle = {}
local imgBackground = {}

game.load = function()
    if (APP_DEBUG) then
        print("Scene game.load()")
    end

    --love.mouse.setCursor(
    --    love.mouse.newCursor("Images/scorpion.png", 0, 0)
    --)
    -- Musique
    music = love.audio.newSource("Sounds/ForestAmbience.mp3", "stream")
    music:setLooping(true)
    music:setPitch(0.75)
    music:setVolume(0.25)
    music:play()
    

    -- Graphique
    imgBeetle.img = love.graphics.newImage("Images/beetle.png")
    imgBeetle.w = imgBeetle.img:getWidth()
    imgBeetle.h = imgBeetle.img:getHeight()
    imgBackground.img = love.graphics.newImage("Images/background.png")

    -- Création /initialisation de la tuile
    tuileList = Tuile.generateTuiles()

    -- Création initialisation des cases
    Case.createCase(200, 150, 108, 108, 1)
    Case.createCase((200 + 108*SCALE + 18), 150, 108, 108, 2)
    Case.createCase(200, (150 + 108*SCALE + 18), 108*SCALE, 108*SCALE, 3)
    Case.createCase((200 + 108*SCALE + 18), (150 + 108*SCALE + 18), 108*SCALE, 108*SCALE, 4)
    caseList = Case.getCaseList()

    
    grpButtons = Gui.newGroup()
    panelButtons = Gui.newPanel(love.graphics.getWidth()/SCALE-180, love.graphics.getHeight()/SCALE-96, 170, 86)
    btnTestSolution = Gui.newButton(panelButtons.X + 10, panelButtons.Y + 10, 150, 28, "Vérifier", fontDefault)
    btnCancel = Gui.newButton(panelButtons.X + 10, panelButtons.Y + 48, 150, 28, "Abandonner", fontDefault)
    btnCancel:setEvent("hover", game.onButtonHover)
    btnTestSolution:setEvent("hover", game.onButtonHover)
    grpButtons:addElement(panelTest)
    grpButtons:addElement(btnCancel)
    grpButtons:addElement(btnTestSolution)
    -- Definition de l'objectif

    -- TODO
    -- Defi numero
end

game.onButtonHover = function (pState)
    print("Button is hover :"..pState)
end


game.unload = function()
    if (APP_DEBUG) then
        print("Scene game.unload()")
    end
end


game.update = function(dt)
    mousePosX = math.floor(love.mouse.getX()/SCALE)
    mousePosY = math.floor(love.mouse.getY()/SCALE)

    grpButtons:update(dt)
    
    for i, case in ipairs(caseList) do
        case.isTuileOverCase = false
        for i, Tuile in ipairs(tuileList) do
            if Tuile.cursorLocked then
                isMouseOverCase = Collide.isPointInsideBox(mousePosX, mousePosY, case)
                if (isMouseOverCase) then
                    case.isTuileOverCase = true
                end
            end
        end
    end
    

    for i, Tuile in ipairs(tuileList) do
        Tuile.update(dt)
    end
    
    -- Ordonnancement des tuiles pour s'assurer que la tuile
    -- accorcher au curseur est toujours affiché en dernier
    table.sort(
        tuileList,
        function(a, b)
          return a.layer < b.layer
        end
    );
end


game.draw = function()
    local color = {}
    color = Utils.ColorFromRgb(70, 63, 50)
    love.graphics.setBackgroundColor(color.r, color.g, color.b)

    love.graphics.draw(
        imgBackground.img, 
        0, 
        0
    )
    
    color = Utils.ColorFromRgb(210, 247, 216)
    love.graphics.setColor(color.r, color.g, color.b)
    
    love.graphics.setFont(fontTitle)
    local sTitre = "Crazy Bugs"
    local w = fontTitle:getWidth(sTitre)
    love.graphics.print(sTitre, ((love.graphics.getWidth() - w)/SCALE) / 2, 20)
    love.graphics.setFont(fontDefault)
    
    -- Dessin des cases
    -- TODO recherche equivalent d'un REDUCE en JS
    local cursorLocked = false
    for i, case in ipairs(caseList) do
        for i, Tuile in ipairs(tuileList) do
            if Tuile.cursorLocked then
                cursorLocked = true
            end
        end
        case.draw(cursorLocked)
    end

    local sDefi = "DEFI 1"
    local sObjectif = "OBJECTIF"
    local w = fontTitle:getWidth(sObjectif)
    love.graphics.print(sDefi, (love.graphics.getWidth() - (w + 20))/SCALE,  100)
    love.graphics.print(sObjectif, (love.graphics.getWidth() - (w + 20))/SCALE,  150)

    love.graphics.draw(
        imgBeetle.img, 
        (love.graphics.getWidth() - (w + 20))/SCALE, 
        200,
        0, -- rotation
        SCALE, SCALE
    )
    love.graphics.print(
        "x 5", 
        (love.graphics.getWidth() - (w + 20))/SCALE + imgBeetle.w/SCALE + 20,
        200 + (imgBeetle.w/SCALE)/2
    )

    grpButtons:draw()


    for i, Tuile in ipairs(tuileList) do
        
        if (Tuile.cursorLocked) then
            posX = love.mouse.getX()/SCALE - Tuile.w / 2
            posY = love.mouse.getY()/SCALE - Tuile.h / 2
        else 
            posX = Tuile.x
            posY = Tuile.y
        end
    
        -- Affichage de la Tuile 
        Tuile.draw(posX, posY)
        isMouseOverTuile = Collide.isPointInsideBox(mousePosX, mousePosY, Tuile)
        if isMouseOverTuile or Tuile.cursorLocked or Tuile.caseId ~= nil then
            love.graphics.rectangle('line', posX, posY, Tuile.w, Tuile.h)
        end
    end
   
    love.graphics.print("X: " .. mousePosX, 10, 10)
    love.graphics.print("Y: " .. mousePosY, 10, 30)
end 


game.keypressed = function(key)
    
    if (key == 'm') then
        SceneManager.switch('menu')
    end

end

game.mousepressed = function(x, y, button)
    
    for i, Tuile in ipairs(tuileList) do
        if (button == 1) then
            isMouseOverTuile = Collide.isPointInsideBox(mousePosX, mousePosY, Tuile)
            
            if (isMouseOverTuile and not Tuile.cursorLocked) then -- Récupère une tuile
                Tuile.cursorLocked = true 
                if (Tuile.caseId ~= nill) then --si elle est sur une case, on la libère
                    caseList[Tuile.caseId].isOccupied = false
                    Tuile.caseId = nil
                end
            elseif(Tuile.cursorLocked) then
                Tuile.cursorLocked = false
                Tuile.x = Tuile.originX
                Tuile.y = Tuile.originY
                -- Parcours les cases
                for i, case in ipairs(caseList) do
                    isMouseOverCase = Collide.isPointInsideBox(mousePosX, mousePosY, case)
                    if (isMouseOverCase) then
                        Tuile.depositTuile(case)
                    end
                end
            end

            
        elseif (button == 2) then
            if Tuile.cursorLocked then
                Tuile.rotate() 
            end
        end
    end
end


return game