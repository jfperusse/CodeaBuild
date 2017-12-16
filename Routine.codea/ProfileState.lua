ProfileState = class(State)

function ProfileState:init()
    self.addClock = Clock(0, "Project:UI_Add")
    self.addClock.spriteScale = 0.9
    self.addClock.showNumbers = false
    self.clockSize = 0.08
end

function ProfileState.Instance()
    return states[PROFILE_STATE]
end

function ProfileState:newProfileClock()
    local spr = (#self.clocks % 2) == 0 and "Project:UI_Profile" or "Project:UI_Profile_Girl"
    local clock = Clock(0, spr)
    clock.spriteScale = 0.8
    clock.showNumbers = false
    clock.wrapWidth = 1
    clock.name = "Louis-Felix-Antoine-Le-Premier"
    return clock
end

function ProfileState:enter()
    analytics:view("profile")
    
    self.clocks = {}
    table.insert(self.clocks, self:newProfileClock())
        
    self.selectedClock = 0
    self.touchedClock = 0
    self.touchTotalDelta = 0
    self.movingClock = false
        
    size = 96 * VIEW_SCALE
    local button = AddSpriteButton(WIDTH - size, 0, size, size, "Project:UI_Check", 
        function()
            -- TODO_PROFILES
            --saveProfiles()
            setState(MAIN_STATE)
        end)
    button.spriteScale = 0.8
    
    size = 200 * VIEW_SCALE
    self.trash = AddSpriteButton(WIDTH - size, HEIGHT - size, size, size, "Project:UI_Trash")
    self.trash.spriteScale = 0.8
    self.trash.testFunc = function() return self.movingClock end
end

function ProfileState:canAdd()
    return #self.clocks < 8
end

function ProfileState:draw()
    local numClocks = self:canAdd() and #self.clocks + 1 or #self.clocks
    local clockSize = self.clockSize --getStepClockSize(numClocks)
    for i,v in ipairs(self.clocks) do
        if not self.movingClock or self.touchedClock ~= i then
            local clockPosition = getClockPosition(i, numClocks)
            v:draw(clockPosition.x, clockPosition.y, clockSize, MORNING,
                false, false, false, false)
        end
    end
    if self:canAdd() then
        local clockSize = self.clockSize --getStepClockSize(numClocks)
        local addIndex = numClocks
        local clockPosition = getClockPosition(addIndex, numClocks)
        self.addClock:draw(clockPosition.x, clockPosition.y, clockSize, MORNING,
            false, false, false, false)
    end
    if self.selectedClock ~= 0 then
        local clock = self.clocks[self.selectedClock]
        --mainClock.sprite = clock.sprite
        --mainClock:draw(0.5, 0.5, MAIN_CLOCK_SIZE, MORNING, true, false, true, true)
        clock:draw(0.5, 0.5, MAIN_CLOCK_SIZE, MORNING, true, false, true, true)
    else
        -- TODO_PROFILE
        --[[
        setFontSize(28)
        if #self.clocks > 1 then
            text(localization:get("TapDuration01"), WIDTH / 2, HEIGHT / 2 + 100 * VIEW_SCALE)
            text(localization:get("TapDuration02"), WIDTH / 2, HEIGHT / 2 + 70 * VIEW_SCALE)
            text(localization:get("DragMoveDelete01"), WIDTH / 2, HEIGHT / 2 + 15 * VIEW_SCALE)
            text(localization:get("DragMoveDelete02"), WIDTH / 2, HEIGHT / 2 - 15 * VIEW_SCALE)        
            text(localization:get("TapWakeBed01"), WIDTH / 2, HEIGHT / 2 - 70 * VIEW_SCALE)
            text(localization:get("TapWakeBed02"), WIDTH / 2, HEIGHT / 2 - 100 * VIEW_SCALE)
        else
            text(localization:get("MorningEvening01"), WIDTH / 2, HEIGHT / 2 + 60 * VIEW_SCALE)
            text(localization:get("MorningEvening02"), WIDTH / 2, HEIGHT / 2 + 30 * VIEW_SCALE)        
            text(localization:get("TapToAdd01"), WIDTH / 2, HEIGHT / 2 - 30 * VIEW_SCALE)
            text(localization:get("TapToAdd02"), WIDTH / 2, HEIGHT / 2 - 60 * VIEW_SCALE)        
        end
          ]]
    end
    if self.movingClock then
        local moving = self.clocks[self.touchedClock]
        moving:drawAbsolute(currentTouch.x, currentTouch.y, clockSize, MORNING, 
            false, false, false, false)
    end
end

function ProfileState:update()
    if self.movingClock then
        local closestIndex = 0
        local closestDistSq = 0
        local numClocks = self:canAdd() and #self.clocks + 1 or #self.clocks
        local minClock = 1
        local maxClock = #self.clocks
        for i = minClock, maxClock do
            local clockPosition = getClockPosition(i, numClocks)
            local x = Clock.getScreenX(clockPosition.x)
            local y = Clock.getScreenY(clockPosition.y)
            local diffX = currentTouch.x - x
            local diffY = currentTouch.y - y
            local distSq = diffX * diffX + diffY * diffY
            local maxDist = 100 * VIEW_SCALE
            local maxDistSq = maxDist * maxDist
            if distSq < maxDistSq then
                if closestIndex == 0 or distSq < closestDistSq then
                    closestIndex = i
                    closestDistSq = distSq
                end
            end
        end
        if closestIndex ~= 0 and closestIndex ~= self.touchedClock then
            local clock = table.remove(self.clocks, self.touchedClock)
            table.insert(self.clocks, closestIndex, clock)
            self.touchedClock = closestIndex
            self.selectedClock = closestIndex
        end
    end
end

function ProfileState:touched(touch)
    local touchedClock = false
    
    if self.touchedClock ~= 0 then
        if touch.state == MOVING then
            if not self.movingClock then
                local delta = math.abs(touch.deltaX) + math.abs(touch.deltaY)
                self.touchTotalDelta = self.touchTotalDelta + delta
                if self.touchTotalDelta >= DRAG_DELTA then
                    self.movingClock = true
                    self.trash.spriteTint = nil
                    self.trash.spriteScale = 0.6
                end
            else
                if self.trash:isOver(touch) then
                    self.trash.spriteTint = color(255, 0, 0)
                    self.trash.spriteScale = 0.8
                else
                    self.trash.spriteTint = nil
                    self.trash.spriteScale = 0.6
                end
            end
        elseif touch.state == ENDED then
            if self.trash:isOver(touch) then
                local moving = self.clocks[self.touchedClock]
                analytics:event("profile", "delete", "todo")                
                table.remove(self.clocks, self.touchedClock)
                self.selectedClock = 0
            elseif not self.movingClock then
                self.selectedClock = self.touchedClock
            end
            self.movingClock = false
            self.touchedClock = 0
        end
    end
    
    if self.movingClock then return end
    
    if touch.state ~= BEGAN then return end
        
    if self:canAdd() and self.addClock:isOver(touch) then
        touchedClock = true
        table.insert(self.clocks, self:newProfileClock())
    end
    
    for i,v in ipairs(self.clocks) do
        if v:isOver(touch) then
            --self.selectedClock = i
            self.touchedClock = i
            self.touchTotalDelta = 0
            self.movingClock = false
            touchedClock = true
        end
    end
    
    if not touchedClock then
        self.selectedClock = 0
    end
end
