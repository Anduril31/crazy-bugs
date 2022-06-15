local Case = {}
local caseList = {}

local imgs = {}
table.insert(imgs, love.graphics.newImage("Images/beetle.png")); -- 1
table.insert(imgs, love.graphics.newImage("Images/bug.png")); -- 2
table.insert(imgs, love.graphics.newImage("Images/cockroach.png")); -- 3
table.insert(imgs, love.graphics.newImage("Images/scorpion.png")); -- 4
table.insert(imgs, love.graphics.newImage("Images/worm.png")); -- 5

-- Toute les vignette font la meme taille 
local elementWidth = love.graphics.newImage("Images/worm.png"):getWidth();
local elementHeight = love.graphics.newImage("Images/worm.png"):getHeight();

local template = {}
-- Template 1
table.insert(template, 
    {
       {1,0,3}, {2,5,2}, {4,3,1}
    }
)
-- Template 2
table.insert(template, 
    {
       {5,0,3}, {0,2,1}, {3,4,5}
    }
)
-- Template 3
table.insert(template, 
    {
       {4,1,2}, {5,0,5}, {3,0,4}
    }
)
-- Template 4
table.insert(template, 
    {
       {0,0,0}, {0,4,3}, {5,1,2}
    }
)

Case.createCase = function (x,y,w,h, templateId)
    local newCase = {}
    newCase.id = #caseList + 1
    newCase.map = template[templateId]
    newCase.element = {}
    newCase.element.w = elementWidth * SCALE
    newCase.element.h = elementHeight * SCALE
    newCase.x = x
    newCase.y = y
    newCase.w = newCase.element.w * 3
    newCase.h = newCase.element.h * 3
    newCase.isOccupied = false
    newCase.isTuileOverCase = false


    newCase.draw = function(cursorLocked)
        cursorLocked = cursorLocked or false
        -- Save curent color
        local r, g, b, a = love.graphics.getColor()

        if (newCase.isTuileOverCase) then
            local color = Utils.ColorFromRgb(255, 255, 107)
            love.graphics.setColor(color.r, color.g, color.b)
        elseif not newCase.isOccupied and cursorLocked then 
            local color = Utils.ColorFromRgb(20, 148, 20)
            love.graphics.setColor(color.r, color.g, color.b)
        else
            -- Couleur par défaut
            love.graphics.setColor(r, g, b, a)
        end

        love.graphics.rectangle('line', newCase.x, newCase.y, newCase.w, newCase.h)
        
        local color = Utils.ColorFromRgb(48, 48, 48)
        love.graphics.setColor(color.r, color.g, color.b, 0.85)
        love.graphics.rectangle('fill', newCase.x+1, newCase.y+1, newCase.w-2, newCase.h-2)

        -- Restore color
        love.graphics.setColor(r, g, b, a)

        for l=1, #newCase.map do
            for c=1, #newCase.map[l] do
                if newCase.map[l][c] ~= 0 then
                    love.graphics.draw(
                        imgs[newCase.map[l][c]], 
                        newCase.x + (c-1)*newCase.element.w, 
                        newCase.y + (l-1)*newCase.element.h, 
                        0, -- rotation
                        SCALE, SCALE
                    )
                end
            end
        end 

       
        
    end

    table.insert(caseList, newCase)
end

Case.getCaseList = function()
    return caseList
end

return Case