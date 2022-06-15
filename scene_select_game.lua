select_game = {}

local fontTitle = nil 
local tweening = {}

local groupTest

local levelChoice = 1

select_game.load = function()
    if (APP_DEBUG) then
        print("Scene select_game.load()")
    end
    -- Chargement des ressources communes
    fontTitle = love.graphics.newFont( 'Fonts/emulogic.ttf', 24)
    fontDefault = love.graphics.newFont( 'Fonts/emulogic.ttf', 12)
    fontDebug = love.graphics.newFont( 'Fonts/emulogic.ttf', 9)
    
    local panelX = (love.graphics.getWidth() - (300*SCALE/0.5))/2
    local panelY = love.graphics.getHeight()/2 - (400*SCALE)/2

    panelTest = Gui.newPanel(panelX, panelY, 600, 300)
    panelTest:setEvent("hover", select_game.onPanelHover)
    text = Gui.newText(panelTest.X + 10, panelTest.Y + 10, 300, 28, "HULL STATUS", fontDefault, "", "center", {151, 220, 250})
    buttonTest = Gui.newButton(panelTest.X + 10, panelTest.Y + 80, 100, 28, "Test", fontDefault)
    groupTest = Gui.newGroup()
    buttonTest:setEvent("pressed", select_game.onButtonPressed)
    buttonTest:setEvent("hover", select_game.onButtonHover)
    
    checkBoxTest1 = Gui.newCheckbox(panelTest.X + 10, panelTest.Y + 150, 24, 24)
    checkBoxTest1:setImages(
      love.graphics.newImage("Images/dotRed.png"),
      love.graphics.newImage("Images/dotGreen.png")
    )
    checkBoxTest1:setEvent("pressed", onCheckboxSwitch)
    checkBoxTest1:setEvent("pressed", select_game.onCheckboxPressed)

    progressTest1 = Gui.newProgressBar(
        panelTest.X + 10, panelTest.Y + 180, 
        220, 26,
        100,
        {50,50,50}, {250, 129, 50}
    )
    progressTest1:setImages(love.graphics.newImage("Images/progress_grey.png"),
    love.graphics.newImage("Images/progress_orange.png"))

    progressTest2 = Gui.newProgressBar(
        panelTest.X + 10, panelTest.Y + 220 + 70,
        220, 26,
        100,
        {50,50,50}, {250, 129, 50}
    )
    progressTest2:setValue(0)
    progressTest2:setImages(love.graphics.newImage("Images/progress_grey.png"),
    love.graphics.newImage("Images/progress_green.png"))

    groupTest:addElement(panelTest)
    groupTest:addElement(text)
    groupTest:addElement(buttonTest)
    groupTest:addElement(checkBoxTest1)
    groupTest:addElement(progressTest1)
    groupTest:addElement(progressTest2)

end

select_game.onCheckboxPressed = function (pState)
    print("Checkbox is pressed :"..pState)
end
select_game.onButtonPressed = function (pState)
    print("Button is pressed :"..pState)
end
select_game.onButtonHover = function (pState)
    print("Button is hover :"..pState)
end
select_game.onPanelHover = function (pState)
    print("Panel is hover :"..pState)
end

select_game.unload = function()
    if (APP_DEBUG) then
        print("Scene select_game.unload()")
    end
end

select_game.update = function(dt)
    groupTest:update(dt)
    if progressTest1.Value > 0.01 then
        progressTest1:setValue(progressTest1.Value - 0.01)
      end
      if progressTest2.Value < 100 then
        progressTest2:setValue(progressTest2.Value + 0.01)
      end
end

select_game.draw = function()
   --[[
    love.graphics.setFont(fontTitle)

    local sTitre = "Select a game"
    local w = fontTitle:getWidth(sTitre)
    love.graphics.print(sTitre, (love.graphics.getWidth() - w) / 2, 50)
    love.graphics.rectangle('fill', (love.graphics.getWidth() - w) / 2, 100, w, 25)
    
    love.graphics.setFont(fontDefault)
    love.graphics.print("(P)   Play", 250, 300)
    ]] --
    groupTest:draw()
end

select_game.keypressed = function(key)
    -- P pour lancer la partie
    if (key == 'p') then
        SceneManager.switch('game')
    end
end


return select_game
