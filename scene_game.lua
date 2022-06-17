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

local imgBackground = {}
local imgTitle = {}
local caseImgs = {}

local tDefis = require("defis")
local tCompteur = {}
local currentDefi = 0

game.load = function()
    if (APP_DEBUG) then
        print("Scene game.load()")
    end

    -- Musique
    music = love.audio.newSource("Sounds/ForestAmbience.mp3", "stream")
    music:setLooping(true)
    music:setPitch(0.75)
    music:setVolume(0.25)
    music:play()
    
    -- Graphique

    -- Background
    imgBackground.img = love.graphics.newImage("Images/background.png")
    -- Titre
    imgTitle.img = love.graphics.newImage("Images/title.png")

    -- Création / Initialisation de la Tuile
    tuileList = Tuile.generateTuiles()

    -- Création initialisation des cases
    Case.createCase(200, 150, 108, 108, 1)
    Case.createCase((200 + 108*SCALE + 18), 150, 108, 108, 2)
    Case.createCase(200, (150 + 108*SCALE + 18), 108*SCALE, 108*SCALE, 3)
    Case.createCase((200 + 108*SCALE + 18), (150 + 108*SCALE + 18), 108*SCALE, 108*SCALE, 4)

    caseList = Case.getCaseList()
    caseImgs = Case.getCaseImgs()

    -- UI
    grpButtons = Gui.newGroup()
    panelButtons = Gui.newPanel(love.graphics.getWidth()/SCALE-180, love.graphics.getHeight()/SCALE-96, 170, 86)
    btnTestSolution = Gui.newButton(panelButtons.X + 10, panelButtons.Y + 10, 150, 28, "Vérifier", fontDefault)
    btnCancel = Gui.newButton(panelButtons.X + 10, panelButtons.Y + 48, 150, 28, "Abandonner", fontDefault)
    btnCancel:setEvent("pressed", game.onButtonPressedCancel)
    btnTestSolution:setEvent("pressed", game.onButtonPressedTestSolution)
    grpButtons:addElement(panelTest)
    grpButtons:addElement(btnCancel)
    grpButtons:addElement(btnTestSolution)
    
    -- Definition de l'objectif

    -- TODO
    -- Defi numero
    file = love.filesystem.newFile("save.cb")
    file:open("r")
    data = file:read()
    file:close()
    if (tonumber(data) == nil) then
        currentDefi = 1
    else
        currentDefi = tonumber(data)
    end
end

-- Bouton abandonner (retour au menu)
game.onButtonPressedCancel = function (pState)
    if (APP_DEBUG) then print("Button is hover :"..pState) end
    SceneManager.switch('menu')
end

game.onButtonPressedTestSolution = function (pState)
    if (APP_DEBUG) then print("Button test solution is pressed : "..pState) end
    
    local tCompteur = {
        0, 0, 0, 0, 0
    }

    for i, case in ipairs(caseList) do
        -- La case n'est pas occupée solution incorrecte
        if not case.isOccupied then 
            return false 
        end

        for i, tuile in ipairs(tuileList) do
            if tuile.caseId == case.id then
                local tElements = tuile.element.map[tuile.rotation]
                for l=1, #tElements do
                    for c=1, #tElements[l] do
                        if tElements[l][c] == 0 then -- Pas de cailloux on regarde dessous
                            caseElement = case.map[l][c]
                            if (caseElement ~= 0) then
                                tCompteur[caseElement] = tCompteur[caseElement] + 1
                            end
                        end
                    end
                end
                break -- On sort de la boucle for
            end
        end
    end

    -- vérifie le résultat
    for i, v in ipairs(tDefis[currentDefi]) do
        if tCompteur[i] ~= v then
            return false -- La solution est incorrecte
        end
    end
    
    -- Solution correcte
    -- Passage au défi suivant
    if currentDefi < #tDefis then
        currentDefi = currentDefi + 1
        -- Enregistrement de l'avancement
        file = love.filesystem.newFile("save.cb")
        file:open("w")
        data = file:write(currentDefi)
        file:close()
    end
    return true
end

game.unload = function()
    if (APP_DEBUG) then print("Scene game.unload()") end
    music:stop()
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

    -- Affichage du background
    love.graphics.draw(
        imgBackground.img, 
        0, 
        0
    )
    
    -- Affichage du titre
    love.graphics.draw(
        imgTitle.img, 
        120, 
        20
    )
    
       
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

    color = Utils.ColorFromRgb(210, 247, 216)
    love.graphics.setColor(color.r, color.g, color.b)
    love.graphics.setFont(fontDefault)

    local sDefi = "DEFI"
    local sCurrentDefi = currentDefi .. " / " .. #tDefis
    local sObjectif = "OBJECTIF"
    local w = fontTitle:getWidth(sObjectif)

    local color = Utils.ColorFromRgb(48, 48, 48)
    love.graphics.setColor(color.r, color.g, color.b, 0.85)
    love.graphics.rectangle( 
        "fill", 
        (love.graphics.getWidth() - w - 40)/SCALE,
        80,
        170,
        (love.graphics.getHeight() - 110)/SCALE
    )

    color = Utils.ColorFromRgb(210, 247, 216)
    love.graphics.setColor(color.r, color.g, color.b)

    
    love.graphics.print(sDefi, (love.graphics.getWidth() - (w + 20))/SCALE,  100)
    love.graphics.print(sCurrentDefi, (love.graphics.getWidth() - (w + 20))/SCALE,  120)
    love.graphics.print(sObjectif, (love.graphics.getWidth() - (w + 20))/SCALE,  160)

    local index = 1
    for i, objectif in ipairs(tDefis[currentDefi]) do
        if (objectif ~= 0) then
            -- image de l'insecte
            love.graphics.draw(
                caseImgs[i], 
                (love.graphics.getWidth() - (w + 20))/SCALE, 
                150 + (index * 50),
                0, -- rotation
                SCALE, SCALE
            )
            -- nombre d'insectes
            love.graphics.print(
                "x "..objectif, 
                (love.graphics.getWidth() - (w + 20))/SCALE + caseImgs[i]:getWidth()/SCALE + 20,
                150 + (index * 50) + (caseImgs[i]:getWidth()/SCALE)/2
            ) 
            
            index = index + 1
        end
    end
    

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
   
    --love.graphics.print("X: " .. mousePosX, 10, 10)
    --love.graphics.print("Y: " .. mousePosY, 10, 30)
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