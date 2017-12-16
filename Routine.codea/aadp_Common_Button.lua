Button = class()

buttons = {}

Button.useAppFont = false

function AddButton(in_x, in_y, in_width, in_height, in_text, in_func, in_tag)
    local button = Button(in_x, in_y, in_width, in_height, in_text, in_func, in_tag)
    table.insert(buttons, button)
    return button
end

function CreateSpriteButton(in_x, in_y, in_width, in_height, in_sprite, in_func, in_tag)
    local button = Button(in_x, in_y, in_width, in_height, nil, in_func, in_tag)
    button.sprite = in_sprite
    button.spriteFit = true
    button.drawRectangle = false
    return button
end

function AddSpriteButton(in_x, in_y, in_width, in_height, in_sprite, in_func, in_tag)
    local button = CreateSpriteButton(in_x, in_y, in_width, in_height, in_sprite, in_func, in_tag)
    table.insert(buttons, button)
    return button
end

function removeButtonWithTag(in_tag)
    for i, v in ipairs(buttons) do
        if v.tag == in_tag then
            table.remove(buttons, i)
            return
        end
    end
end

function removeLastButtonWithTag(in_tag)
    for i = 1, #buttons do
        j = #buttons - i + 1
        v = buttons[j]
        if v.tag == in_tag then
            table.remove(buttons, j)
            return
        end        
    end
end

function hasButtonWithTag(in_tag)
    for i, v in ipairs(buttons) do
        if v.tag == in_tag then
            return true
        end
    end
    return false
end

function Button:init(in_x, in_y, in_width, in_height, in_text, in_func, in_tag)
    self.x = in_x
    self.y = in_y
    self.width = in_width
    self.height = in_height
    self.right = in_x + in_width
    self.top = in_y + in_height
    self.font = "AmericanTypewriter-Bold"
    self.text = in_text
    self.textSize = 32
    self.func = in_func
    self.center = vec2(in_x + 0.5 * in_width, in_y + 0.5 * in_height)
    self.textColor = color(255, 255, 255, 255)
    self.testFunc = nil
    self.sprite = nil
    self.spriteScale = 1
    self.spriteFit = false
    self.spriteTint = nil
    self.tag = in_tag
    self.localizedText = false
    self.localizedArray = nil
    self.selectedFunc = nil
    self.releasedFunc = nil
    self.touchId = -1
    self.useAppFont = Button.useAppFont
    self.drawRectangle = true
end

function Button:setTextColor(in_color)
    self.textColor = in_color
end

function Button:setTextSize(in_size)
    self.textSize = in_size
end

function Button:setTestFunc(in_func)
    self.testFunc = in_func
end

function Button:setReleasedFunc(in_func)
    self.releasedFunc = in_func
end

function Button:setSprite(in_sprite)
    self.sprite = in_sprite
end

function Button:setSpriteWithScale(in_sprite, in_scale)
    self.sprite = in_sprite
    self.spriteScale = in_scale
end

function Button:setUseAppFont()
    self.useAppFont = true
end

function Button:draw()
    if self.testFunc ~= nil and self.testFunc() == false then
        return
    end
    
    pushStyle()
    
    if not self.useAppFont then
        font(self.font)
        fontSize(self.textSize)
    end
    
    if self.drawRectangle then
        strokeWidth(5)
        stroke(255, 255, 255, 255)
        
        if self.selectedFunc ~= nil and self.selectedFunc() == true then
            fill(201, 201, 201, 255)
        else
            fill(101, 101, 101, 255)
        end
        
        rectMode(CORNER)
        rect(self.x, self.y, self.width, self.height)
    end

    fill(self.textColor)
    textMode(CENTER)
    textAlign(CENTER)
    if self.localizedText then
        if self.localizedArray ~= nil then
            text(localization:get(self.text, self.localizedArray), self.center.x, self.center.y)
        else
            text(localization:get(self.text), self.center.x, self.center.y)
        end
    elseif self.text then
        text(self.text, self.center.x, self.center.y)
    end
    if self.sprite ~= nil then
        spriteMode(CENTER)
        pushMatrix()
        translate(self.center.x, self.center.y)
        scale(self.spriteScale)
        local backupTint = tint()
        if self.spriteTint ~= nil then
            tint(self.spriteTint)
        end
        if self.spriteFit then
            sprite(self.sprite, 0, 0, self.width, self.height)
        else
            sprite(self.sprite)
        end
        if self.spriteTint ~= nil then
            tint(backupTint)
        end
        popMatrix()
    end
    
    popStyle()
end

function Button:isOver(touch)
    if self.testFunc ~= nil and self.testFunc() == false then
        return false
    end
    return touch.x > self.x and touch.x < self.right and
           touch.y > self.y and touch.y < self.top
end

function Button:touched(touch)
    if self:isOver(touch) then
        if self.touchId == -1 and touch.state == BEGAN then
            self.pressed = true
            self.touchId = touch.id
            if self.func ~= nil then
                self.func()
            end
            return true
        end
    end
    if touch.state == ENDED and self.touchId == touch.id then
        self.touchId = -1
        if self.releasedFunc ~= nil then
            self.releasedFunc()
        end
    end
    return false
end

function DrawButtons()
    for i,v in ipairs(buttons) do
        v:draw()
    end
end

function UpdateButtons(touch)
    local anyButton = false
    
    for i,v in ipairs(buttons) do
        anyButton = v:touched(touch) or anyButton 
    end
    
    return anyButton
end