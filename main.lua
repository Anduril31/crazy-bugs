--love.graphics.setDefaultFilter("nearest", "nearest")

-- Valeur de "zoom" par défaut
SCALE = 1.2

-- Chargement lib utilitaire
Utils = require("libs.utils.Utils")
Collide = require("libs.utils.Collide")
EffectManager = require("libs.utils.EffectManager")
Gui = require("libs.utils.Gui")

-- Chargement du scene manager 
SceneManager = require('SceneManager')

fontTitle, fontDefault, fontDebug = nil, nil, nil

function love.load()
    --love.window.setFullscreen(true, "desktop")
    if (APP_DEBUG) then 
        print(love.filesystem.getSaveDirectory())
    end
    
    -- Création du fichier de sauvegarde s'il n'existe pas
    info = love.filesystem.getInfo( 'save.cb', info )
    if info == nil then
        local success, message = love.filesystem.write( 'save.cb', "")
        if not success then 
            print ('Impossible de créer le fichier de sauvegarde : '..message)
        end
    end

    -- Ajout des scènes
    SceneManager.addScene('menu');
    --SceneManager.addScene('select_game');
    SceneManager.addScene('game');

    --SceneManager.addScene('game');

    -- Définition de de la scène par défaut
    SceneManager.setCurrentSceneName('menu')

    -- Chargement des ressources communes
    fontTitle = love.graphics.newFont('Fonts/Xolonium-Bold.ttf', 30)
    fontDefault = love.graphics.newFont('Fonts/Xolonium-Regular.ttf', 16)
    fontDebug = love.graphics.newFont('Fonts/Xolonium-Regular.ttf', 10)

    SceneManager.load()
end

function love.update(dt)
    SceneManager.update(dt)
end

function love.draw()
    love.graphics.scale(SCALE, SCALE)
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


