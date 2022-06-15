APP_VERSION = "v0.1"
APP_DEBUG = true
APP_DEBUG_CONSOLE = false -- Desactive la console pour permettre le debuggage pas à pas.


if (APP_DEBUG) then

    -- Utilisation du debugger LUA
    if (APP_DEBUG_CONSOLE) then
        print("*****************************************************")
        print("Le debugger n'est pas disponible")
        print("Pour l'utiliser APP_DEBUG_CONSOLE doit être à FALSE")
        print("*****************************************************")
    else 
        if pcall(require, "lldebugger") then
            require("lldebugger").start()
            print("*****************************************************")
            print("Activation du debugger")
            print("*****************************************************")
        end
    end
       
    -- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
    io.stdout:setvbuf("no")
end


function love.conf(t)
    t.window.title = "Crazy Bugs "..APP_VERSION         -- The window title (string)
    t.window.width = 1024
    t.window.height = 768

    if (APP_DEBUG and APP_DEBUG_CONSOLE) then
        t.console = true
    end
end