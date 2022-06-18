local Gui = {}

local function newElement(pX, pY)
    local myElement = {}
    myElement.X = pX
    myElement.Y = pY
    
    function myElement:draw()
        print("newElement / draw / Not implemented")
    end
    
    function myElement:update(dt)
        print("newElement / update / Not implemented")
    end

    function myElement:setVisible(pVisible)
        self.Visible = pVisible
    end

    return myElement
end


function Gui.newText(pX, pY, pW, pH, pText, pFont, pHAlign, pVAlign, pColor)
    local myText = Gui.newPanel(pX, pY, pW, pH)
    myText.Text = pText
    myText.Font = pFont
    myText.TextW = pFont:getWidth(pText)
    myText.TextH = pFont:getHeight(pText)
    myText.HAlign = pHAlign
    myText.VAlign = pVAlign
    myText.Color = pColor

    function myText:drawText()
        love.graphics.setFont(self.Font)
        if self.Color ~= nil then
            love.graphics.setColor(self.Color[1]/255, self.Color[2]/255, self.Color[3]/255)
        else
            love.graphics.setColor(1,1,1)
        end
        local x = self.X
        local y = self.Y
        if self.HAlign == "center" then
            x = x + ((self.W - self.TextW) / 2)
        end
        if self.VAlign == "center" then
            y = y + ((self.H - self.TextH) / 2)
        end
        love.graphics.print(self.Text, x, y)
    end

    function myText:draw()
        if self.Visible == false then return end
        self:drawText()
    end

    return myText
  end

function Gui.newPanel(pX, pY, pW, pH, pBgColor, pBorderColor)
    local myPanel = newElement(pX, pY)
    myPanel.W = pW
    myPanel.H = pH
    myPanel.Image = nil
    myPanel.isHover = false
    myPanel.lstEvents = {}
    myPanel.BgColor = pBgColor or nil
    myPanel.BorderColor = pBorderColor or nil
  
    function myPanel:setImage(pImage)
        self.Image = pImage
        self.W = pImage:getWidth()
        self.H = pImage:getHeight()
    end

    function myPanel:setEvent(pEventType, pFunction)
        self.lstEvents[pEventType] = pFunction
    end

    function myPanel:updatePanel(dt)
        local mx,my = love.mouse.getPosition()
        mx = mx/SCALE
        my = my/SCALE
        if mx > self.X and mx < self.X + self.W and my > self.Y and my < self.Y + self.H then
            if self.isHover == false then
                self.isHover = true
                if self.lstEvents["hover"] ~= nil then
                    self.lstEvents["hover"]("begin")
                end
            end
        else
            if self.isHover == true then
                self.isHover = false
                if self.lstEvents["hover"] ~= nil then
                    self.lstEvents["hover"]("end")
                end
            end
        end
    end

    function myPanel:drawPanel()
        love.graphics.setColor(1,1,1)
        if self.Image == nil then
            if self.BgColor ~= nil then
                if #self.BgColor == 4 then -- RGBA
                    love.graphics.setColor(self.BgColor[1]/255, self.BgColor[2]/255, self.BgColor[3]/255, self.BgColor[4])
                else
                    love.graphics.setColor(self.BgColor[1]/255, self.BgColor[2]/255, self.BgColor[3]/255)
                end
                love.graphics.rectangle("fill", self.X, self.Y, self.W, self.H)
            end
            if self.BorderColor ~= nil then
                love.graphics.setColor(self.BorderColor[1]/255, self.BorderColor[2]/255, self.BorderColor[3]/255)
            end
            love.graphics.rectangle("line", self.X, self.Y, self.W, self.H)

        else
            love.graphics.draw(self.Image, self.X, self.Y)
        end
        
    end

    function myPanel:draw()
        if self.Visible == false then return end
        self:drawPanel()
    end

    function myPanel:update(dt)
        self:updatePanel()
    end

    return myPanel
end

function Gui.newCheckbox(pX, pY, pW, pH)
    local myCheckbox = Gui.newPanel(pX, pY, pW, pH)
    myCheckbox.imgDefault = nil
    myCheckbox.imgPressed = nil
    myCheckbox.isPressed = false
    myCheckbox.oldButtonState = false

    function myCheckbox:setImages(pImageDefault, pImagePressed)
        self.imgDefault = pImageDefault
        self.imgPressed = pImagePressed
        self.W = pImageDefault:getWidth()
        self.H = pImageDefault:getHeight()
    end

    function myCheckbox:setState(pbState)
        self.isPressed = pbState
      end

    function myCheckbox:update(dt)
        self:updatePanel(dt)
        if self.isHover and love.mouse.isDown(1) and self.isPressed == false and self.oldButtonState == false then
          self.isPressed = true
          if self.lstEvents["pressed"] ~= nil then
            self.lstEvents["pressed"]("on")
          end
        else
          if self.isHover and self.isPressed == true and love.mouse.isDown(1) and self.oldButtonState == false then
            self.isPressed = false 
            if self.lstEvents["pressed"] ~= nil then
              self.lstEvents["pressed"]("off")
            end
          end
        end
        self.oldButtonState = love.mouse.isDown(1)



    end

    function myCheckbox:draw()
        love.graphics.setColor(255,255,255)
        if self.isPressed then
            if self.imgPressed == nil then
                self:drawPanel()
                love.graphics.setColor(255,255,255,50)
                love.graphics.rectangle("fill", self.X, self.Y, self.W, self.H)
            else
                love.graphics.draw(self.imgPressed, self.X, self.Y)
            end
        else
            if self.imgDefault == nil then
                self:drawPanel()
            else
                love.graphics.draw(self.imgDefault, self.X, self.Y)
            end
        end
    end

    return myCheckbox
end


function Gui.newButton(pX, pY, pW, pH, pText, pFont, pColor, pBackColor, data)
    local myButton = Gui.newPanel(pX, pY, pW, pH)
    myButton.Text = pText
    myButton.Font = pFont
    myButton.Label = Gui.newText(pX, pY, pW, pH, pText, pFont, "center", "center", pColor)
    myButton.imgDefault = nil
    myButton.imgHover = nil
    myButton.imgPressed = nil
    myButton.isPressed = false
    myButton.oldButtonState = false
    myButton.color = pColor or {255,255,255}
    myButton.backColor = pBackColor or {255,255,255}
    myButton.data = data or {}


    function myButton:setImages(pImageDefault, pImageHover, pImagePressed)
        self.imgDefault = pImageDefault
        self.imgHover = pImageHover
        self.imgPressed = pImagePressed
        self.W = pImageDefault:getWidth()
        self.H = pImageDefault:getHeight()
    end

    function myButton:update(dt)
        self:updatePanel(dt)
        if self.isHover and love.mouse.isDown(1) and self.isPressed == false and self.oldButtonState == false then
          self.isPressed = true
          if self.lstEvents["pressed"] ~= nil then
            self.lstEvents["pressed"]("begin",self.data)
          end
        else
          if self.isPressed == true and love.mouse.isDown(1) == false then
            self.isPressed = false
            if self.lstEvents["pressed"] ~= nil then
              self.lstEvents["pressed"]("end")
            end
          end
        end
        self.oldButtonState = love.mouse.isDown(1)



    end

    function myButton:draw()
        love.graphics.setColor(255,255,255)
        if self.isPressed then
            if self.imgPressed == nil then
                self:drawPanel()
                love.graphics.setColor(myButton.backColor[1],myButton.backColor[2],myButton.backColor[3],50)
                love.graphics.rectangle("fill", self.X, self.Y, self.W, self.H)
            else 
                love.graphics.draw(self.imgPressed, self.X, self.Y)
            end
        elseif self.isHover then
            if self.imgHover == nil then
                self:drawPanel()
                love.graphics.setColor(myButton.color[1],myButton.color[2],myButton.color[3])
                love.graphics.rectangle("line", self.X+2, self.Y+2, self.W-4, self.H-4)
            else
                love.graphics.draw(self.imgHover, self.X, self.Y)
            end
        else
            if self.imgDefault == nil then
                self:drawPanel()
            else
                love.graphics.draw(self.imgDefault, self.X, self.Y)
            end    
        end
        self.Label:draw()
    end

    return myButton
end


function Gui.newProgressBar(pX, pY, pW, pH, pMax, pColorOut, pColorIn)
    local myProgressBar = Gui.newPanel(pX, pY, pW, pH)
    myProgressBar.ColorOut = pColorOut
    myProgressBar.ColorIn = pColorIn
    myProgressBar.Max = pMax
    myProgressBar.Value = pMax
    myProgressBar.imgBack = nil
    myProgressBar.imgBar = nil
  
    function myProgressBar:setImages(pImageBack, pImageBar)
        self.imgBack = pImageBack
        self.imgBar = pImageBar
        self.W = pImageBack:getWidth()
        self.H = pImageBack:getHeight()
    end
  
    function myProgressBar:setValue(pValue)
        if pValue >= 0 and pValue <= self.Max then
            self.Value = pValue
        else
            print("myProgressBar:setValue error - out of range")
        end
    end
  
    function myProgressBar:draw()
        love.graphics.setColor(1,1,1)
        local barSize = (self.W - 2) * (self.Value / self.Max)
        if self.imgBack ~= nil and self.imgBar ~= nil then
            love.graphics.draw(self.imgBack, self.X, self. Y)
            local barQuad = love.graphics.newQuad(0, 0, barSize, self.H, self.W, self.H)
            love.graphics.draw(self.imgBar, barQuad, self.X, self. Y)
        else
            self:drawPanel()
            if self.ColorOut ~= nil then
                love.graphics.setColor(self.ColorIn[1]/255, self.ColorIn[2]/255, self.ColorIn[3]/255)
            else
                love.graphics.setColor(1,1,1)
            end
            love.graphics.rectangle("fill", self.X + 1, self.Y + 1, barSize, self.H - 2)
        end
    end
    
    return myProgressBar
end

function Gui.newGroup()
    local myGroup = {}
    myGroup.elements = {}

    function myGroup:addElement(pElement)
        table.insert(self.elements, pElement)
    end

    function myGroup:setVisible(pVisible)
        for i, element in ipairs(myGroup.elements) do
            element:setVisible(pVisible)
        end
    end

    function myGroup:update(dt)
        for i, element in pairs(myGroup.elements) do
            element:update(dt)
        end
    end

    function myGroup:draw()
        -- Notez l'utilisation du push / pop dans le draw. Cela permet de sauvegarder le contexte graphique
        -- à l'entrée et de le restaurer à la fin. Intérêt ? Vous pouvez faire plein de setColor ou des
        -- transformations pendant le draw de votre GUI, tout sera remis comme avant à la fin.
        love.graphics.push()
        for i, element in ipairs(myGroup.elements) do
            element:draw()
        end
        love.graphics.pop()
    end


    return myGroup
end



return Gui