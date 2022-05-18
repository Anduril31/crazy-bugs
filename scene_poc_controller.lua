poc_controller = {}

local scene = {}

local mousePosX = 0
local mousePosY = 0

local isMouseOverTuile = false
local isMouseOverCase = false

local Tuile = require("tuile")
local tuileList = {}

local Case = require("case")
local caseList = {}


poc_controller.load = function()
    if (APP_DEBUG) then
        print("Scene poc_controller.load()")
    end

    --love.mouse.setCursor(
    --    love.mouse.newCursor("Images/scorpion.png", 0, 0)
    --)
    
    -- Création /initialisation de la tuile
    --Tuile.init()
    tuileList = Tuile.generateTuiles()


    -- Création initialisation des cases
    Case.createCase(386/SCALE, 258/SCALE, 108*SCALE, 108*SCALE)
    Case.createCase((386/SCALE + 108*SCALE + 18*SCALE), 258/SCALE, 108*SCALE, 108*SCALE)
    Case.createCase(386/SCALE, (258/SCALE + 108*SCALE + 18*SCALE), 108*SCALE, 108*SCALE)
    Case.createCase((386/SCALE + 108*SCALE + 18*SCALE), (258/SCALE + 108*SCALE + 18*SCALE), 108*SCALE, 108*SCALE)
    caseList = Case.getCaseList()
end


poc_controller.unload = function()
    if (APP_DEBUG) then
        print("Scene poc_controller.unload()")
    end
end


poc_controller.update = function(dt)
    mousePosX = love.mouse.getX()
    mousePosY = love.mouse.getY()

    
    for i, case in ipairs(caseList) do
        case.isTuileOverCase = false
        for i, Tuile in ipairs(tuileList) do
            if Tuile.cursorLocked then
                isMouseOverCase = Collide.isPointInsideBox(mousePosX, mousePosY, case, 20*SCALE)
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


poc_controller.draw = function()
    
    love.graphics.setBackgroundColor(0, 0, 0)
    
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

    for i, Tuile in ipairs(tuileList) do
        
        if (Tuile.cursorLocked) then
            posX = love.mouse.getX() - Tuile.w / 2
            posY = love.mouse.getY() - Tuile.h / 2
        else 
            posX = Tuile.x
            posY = Tuile.y
        end
    
        -- Affichage de la Tuile 
        Tuile.draw(posX, posY)
        isMouseOverTuile = Collide.isPointInsideBox(mousePosX, mousePosY, Tuile)
        if isMouseOverTuile or Tuile.cursorLocked then
            love.graphics.rectangle('line', posX, posY, Tuile.w, Tuile.h)
        end
    end
   
    love.graphics.print("X: " .. mousePosX, 10, 10)
    love.graphics.print("Y: " .. mousePosY, 10, 30)

end 


poc_controller.keypressed = function(key)
    
    if (key == 'm') then
        SceneManager.switch('menu')
    end

end

poc_controller.mousepressed = function(x, y, button)
    
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
                    isMouseOverCase = Collide.isPointInsideBox(mousePosX, mousePosY, case, 20*SCALE)
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


return poc_controller