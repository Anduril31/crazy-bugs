local SceneManager = {}

    -- -------------
    -- Private scope
    -- -------------
    local scenes = {} -- Liste des scènes (écran)
    local currentSceneName = nil -- Nom de la scène courante
    local currentScene = nil -- Scène courante

    -- Charge une scène
    local loadScene = function ()
        sceneName = SceneManager.getCurrentSceneName()
        currentScene = require('scene_'..sceneName)

        return currentScene
    end

    -- Décharge une scène
    local unLoad = function ()
        SceneManager.setCurrentSceneName(nil)
        currentScene = nil
    end

    -- Vérifie si la scène demandée existe
    local sceneExist = function(sceneName)
        for i, scene in ipairs(scenes) do
            if (scene == sceneName) then
                return true
            end
        end
        return false
    end

    -- -------------
    -- Public scope
    -- -------------

    -- Ajoute une scène à la liste des scènes
    SceneManager.addScene = function(sceneName)
        table.insert(scenes, sceneName)
    end

    -- Définit le nom de la scène par défaut
    SceneManager.setCurrentSceneName = function(sceneName)
        if (sceneName ~= nil) then
            if (sceneExist(sceneName)) then
                currentSceneName = sceneName
            else 
                print("Erreur: La scène " .. tostring(sceneName) .. " n'existe pas")
            end
        end
    end

    -- Retourne le nom de la scène courante
    SceneManager.getCurrentSceneName = function()
        return currentSceneName
    end

    -- Retourne la scène courante
    SceneManager.getCurrentScene = function()
        return currentScene
    end

        -- Retourne la liste des scènes
        SceneManager.getScenes = function()
        return scenes
    end


    -- Change de scène
    SceneManager.switch = function(sceneName, isUnloadCurrentScene)
        isUnloadCurrentScene = isUnloadCurrentScene or true -- Valeur par défaut
        if (not type(isUnloadCurrentScene) == "boolean") then
            print("Erreur: isUnloadCurrentScene doit être un booléen")
        end

        if sceneExist(sceneName) then
            if (APP_DEBUG) then
                print("Switch to scene: "..sceneName)
                print("Scene found: "..sceneName)
            end
            if (isUnloadCurrentScene) then -- Décharge la scène courante
                if (APP_DEBUG) then
                    print("Unload current scene")
                end
                SceneManager.unLoad() 
            end
            SceneManager.setCurrentSceneName(sceneName)
            SceneManager.load()
        else 
            print("Erreur:  La scène "..sceneName.." n'existe pas")
        end
    end

    -- Charge la scène courante et la retourne
    SceneManager.load = function() 
        if (APP_DEBUG) then
            print("Load scene: "..SceneManager.getCurrentSceneName())
        end
        loadScene()
        if not currentScene.load then
            print("Scene "..SceneManager.getCurrentSceneName().." has no load function")
        end
        currentScene.load()
    end

    -- Décharge la scène courante
    SceneManager.unLoad = function()
        if not currentScene.unload then
            print("Scene "..SceneManager.getCurrentSceneName().." has no unload function")
        end
        currentScene.unload()
        if (APP_DEBUG) then
            print("Unload scene: "..SceneManager.getCurrentSceneName())
        end
        unLoad()
    end

        
    SceneManager.update = function(dt)
        currentScene.update(dt)
    end

    SceneManager.draw = function()
        currentScene.draw()
    end

    SceneManager.keypressed = function(key)
        if currentScene.keypressed then
            currentScene.keypressed(key)
        end
    end

    SceneManager.mousepressed = function(x, y, button, istouch, presses)
        if currentScene.mousepressed then
            currentScene.mousepressed(x, y, button, istouch, presses)
        end
    end
    
    SceneManager.mousereleased = function(x, y, button, istouch, presses)
        if currentScene.mousereleased then
            currentScene.mousereleased(x, y, button, istouch, presses)
        end
    end
    
    SceneManager.mousemoved = function( x, y, dx, dy, istouch )
        if currentScene.mousemoved then
            currentScene.mousemoved(x, y, dx, dy, istouch)
        end
    end
    
    SceneManager.mousefocus = function( focus )
        if currentScene.mousefocus then
            currentScene.mousefocus(focus)
        end
    end

    -- TODO: Ajouter les autres fonctions si besoins
    -- https://love2d.org/wiki/Category:Callbacks

return SceneManager