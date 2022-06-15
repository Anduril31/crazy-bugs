local Tuile = {}

local MAX_TUILES = 4
local lstTuiles = {}
local tuileMaps = {}

table.insert(tuileMaps, 
    {
        { {1,1,0}, {0,1,1}, {0,1,1} },
        { {0,0,1}, {1,1,1}, {1,1,0} },
        { {1,1,0}, {1,1,0}, {0,1,1} },
        { {0,1,1}, {1,1,1}, {1,0,0} }
    }
)
table.insert(tuileMaps, 
    {
        { {1,1,0}, {1,1,1}, {1,0,1} },
        { {1,1,1}, {0,1,1}, {1,1,0} },
        { {1,0,1}, {1,1,1}, {0,1,1} },
        { {0,1,1}, {1,1,0}, {1,1,1} }
    }
)
table.insert(tuileMaps, 
    {
        { {1,0,1}, {1,0,1}, {1,1,1} },
        { {1,1,1}, {1,0,0}, {1,1,1} },
        { {1,1,1}, {1,0,1}, {1,0,1} },
        { {1,1,1}, {0,0,1}, {1,1,1} },
    }
)
table.insert(tuileMaps, 
    {
        { {1,0,1}, {1,1,1}, {1,0,1} },
        { {1,1,1}, {0,1,0}, {1,1,1} },
        { {1,0,1}, {1,1,1}, {1,0,1} },
        { {1,1,1}, {0,1,0}, {1,1,1}},
    }
)

Tuile.generateTuiles = function()
    local i
    for i=1, MAX_TUILES do
        local Tuile = {}
        Tuile.id = i
        Tuile.layer = i
        Tuile.img = love.graphics.newImage("Images/rock.png")
        Tuile.caseId = nil
        Tuile.cursorLocked = false
        Tuile.rotation = 1
        Tuile.element = {}
        Tuile.element.w = Tuile.img:getWidth() * SCALE
        Tuile.element.h = Tuile.img:getHeight() * SCALE
        Tuile.element.map = tuileMaps[i]
        Tuile.w = Tuile.element.w * 3
        Tuile.h = Tuile.element.h * 3
        Tuile.x = 45 + ( Tuile.w * (i-1) ) + ( (i-1) * 22)
        Tuile.y = love.graphics.getHeight()/SCALE-(Tuile.h + 10)
        Tuile.originX = Tuile.x
        Tuile.originY = Tuile.y
        -- Rotation de la tuile
        Tuile.rotate = function()
            Tuile.rotation = Tuile.rotation + 1
            if (Tuile.rotation > 4) then
                Tuile.rotation = 1
            end
        end

        -- Deposer une tuile sur une case
        Tuile.depositTuile = function(case)
            Tuile.x = case.x
            Tuile.y = case.y
            case.isOccupied = true
            Tuile.caseId = case.id
        end 

        Tuile.update = function(dt)
            if Tuile.cursorLocked then
                Tuile.layer = MAX_TUILES + 1
            else
                Tuile.layer = Tuile.id
            end
        
        end



        -- Affiche la Tuile
        Tuile.draw = function(posX, posY)
            posX = posX or Tuile.x
            posY = posY or Tuile.y

            -- Dessin des emplacements d'origine
            -- Save curent color
            local r, g, b, a = love.graphics.getColor()
            local color = Utils.ColorFromRgb(48, 48, 48)
            
            love.graphics.setColor(color.r, color.g, color.b, 0.85)
            love.graphics.rectangle('fill', Tuile.originX , Tuile.originY, Tuile.w, Tuile.h)

            local map = Tuile.element.map[Tuile.rotation]
            for l=1, #map do
                for c=1, #map[l] do
                    if map[l][c] == 1 then
                        
                        love.graphics.setColor(color.r, color.g, color.b)
                        love.graphics.rectangle(
                            'fill', 
                            posX + (c-1) * Tuile.element.w, 
                            posY + (l-1) * Tuile.element.h,
                            Tuile.element.w, Tuile.element.h
                        )
                        love.graphics.setColor(r ,g, b, 0.90)
                        love.graphics.draw(
                            Tuile.img, 
                            posX + (c-1)*Tuile.element.w, posY + (l-1)*Tuile.element.h, 
                            0, -- rotation
                            SCALE, SCALE
                        )
                    end
                end
            end 
        end

        table.insert(lstTuiles, Tuile)
    end

    return lstTuiles
end

return Tuile