love.graphics.setDefaultFilter("nearest", "nearest")

-- Valeur de "zoom" par défaut
SCALE = 1

-- Chargement lib utilitaire
Utils = require("libs.utils.Utils")
Collide = require("libs.utils.Collide")
EffectManager = require("libs.utils.EffectManager")

-- Chargement du scene manager 
SceneManager = require('SceneManager')


function love.load()
    --love.window.setFullscreen(true, "desktop")

    -- Ajout des scènes
    SceneManager.addScene('menu');
    SceneManager.addScene('poc_controller');
    --SceneManager.addScene('game');

    -- Définition de de la scène par défaut
    SceneManager.setCurrentSceneName('poc_controller')

    SceneManager.load()

end

function love.update(dt)
    SceneManager.update(dt)
end

function love.draw()
    local color = {}

    color = Utils.ColorFromRgb(89, 105, 91)
    love.graphics.setBackgroundColor(color.r, color.g, color.b)
    
    color = Utils.ColorFromRgb(210, 247, 216)
    love.graphics.setColor(color.r, color.g, color.b)

    SceneManager.draw()
end

function love.keypressed(key)
 
    if (APP_DEBUG) then
        -- Panic button to quit
        if (key == 'escape') then
            love.event.quit()
        end
    end
    SceneManager.keypressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
    SceneManager.mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    SceneManager.mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved( x, y, dx, dy, istouch )
    SceneManager.mousemoved(x, y, dx, dy, istouch)
end

function love.mousefocus( focus )
    SceneManager.mousefocus(focus)
end