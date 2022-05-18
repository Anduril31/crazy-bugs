local Case = {}
local caseList = {}

Case.createCase = function (x,y,w,h)
    local newCase = {}

    newCase.id = #caseList + 1
    newCase.x = x
    newCase.y = y
    newCase.w = w
    newCase.h = h
    newCase.isOccupied = false
    newCase.isTuileOverCase = false

    newCase.draw = function(cursorLocked)
        cursorLocked = cursorLocked or false
        -- Save curent color
        local r, g, b, a = love.graphics.getColor()

        if (newCase.isTuileOverCase) then
            love.graphics.setColor(255,0,0)
        elseif not newCase.isOccupied and cursorLocked then 
            love.graphics.setColor(0,255,0)
        else
            -- Couleur par défaut
            love.graphics.setColor(r, g, b, a)
        end

        love.graphics.rectangle('line', newCase.x, newCase.y, newCase.w, newCase.h)
        -- Restore color
        love.graphics.setColor(r, g, b, a)
    end

    table.insert(caseList, newCase)
end

Case.getCaseList = function()
    return caseList
end

return Case