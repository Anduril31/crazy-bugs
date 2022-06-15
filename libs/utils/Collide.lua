local Collide = {}

-- Check if a point is inside a rectangle
-- @param x : X position of the point
-- @param y : Y position of the point
-- @param rect : Rectangle {x, y, w, h, ...}
-- @param tolerance : Margin to add or remove to the rectangle
-- @return : true if the point is inside the rectangle, false otherwise
Collide.isPointInsideBox = function(posX, posY, box, tolerance)
    -- Default value
    tolerance = tolerance or 0
    -- TODO bug sur gestion tolerance

    if (tolerance >= 0) then
        boxPosX = box.x + tolerance
        boxWidth = box.w - tolerance
        boxPosY = box.y + tolerance
        boxHeight = box.h - tolerance
    else

    end

    if (posX > boxPosX and posX < boxPosX + boxWidth) then
        if (posY > boxPosY and posY < boxPosY + boxHeight) then
            return true
        end
    end

    return false
end


return Collide