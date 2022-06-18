local Utils = {}

-- Convertit Color rvb (0 à 255) en couleur "love" de 0 à 1
-- @param rb : Red (0 à 255)
-- @param gb : Green (0 à 255)
-- @param bb : Blue (0 à 255)
-- @param ab : alpha (0 à 255)
-- @return : Couleur "love" de 0 à 1 {r, g, b}
Utils.ColorFromRgb = function(rb, gb, bb, ab)
    local ab = ab or 255
    local rb, gb ,bb , ab = love.math.colorFromBytes( rb, gb, bb, ab )
    return {
        r = rb,
        g = gb,
        b = bb,
        a = ab
    }
end

Utils.readSave = function()
    file = love.filesystem.newFile("save.cb")
    file:open("r")
    data = file:read()
    file:close()
    if (tonumber(data) == nil or tonumber(data) == 0) then
        level = 1
    else
        level = tonumber(data)
    end

    return level
end

Utils.save = function(level)
    file = love.filesystem.newFile("save.cb")
    file:open("w")
    data = file:write(level)
    file:close()
end

return Utils