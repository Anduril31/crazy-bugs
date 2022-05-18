local Utils = {}

-- Convertit Color rvb (0 à 255) en couleur "love" de 0 à 1
-- @param r : Red (0 à 255)
-- @param g : Green (0 à 255)
-- @param b : Blue (0 à 255)
-- @return : Couleur "love" de 0 à 1 {r, g, b}
Utils.ColorFromRgb = function(r, g, b)
    return {
        r = r/255,
        g = g/255,
        b = b/255
    }
end

return Utils