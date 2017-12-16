ModifyRoutineState = class(State)

DRAG_DELTA = 35

function ModifyRoutineState:init()
    self.spriteSelection = SpriteSelection()
    self.showSpriteSelection = false
    self.addClock = Clock(0, "Project:UI_Add")
    self.addClock.spriteScale = 0.9
    self.addClock.showNumbers = false
    self.swappingClock = nil
    
    local date = os.date("*t")
    self.selectedRoutine = (date.hour < 12 and MORNING) or EVENING    
end

function ModifyRoutineState.Instance()
    return states[MODIFY_ROUTINE_STATE]
end

function ModifyRoutineState:addClockFormatButton(index, format, text)
    local y = 0.01 * HEIGHT
    local width = 100 * VIEW_SCALE
 
    button = AddButton(WIDTH / 2 - 1 * width + index * width, y, width, 50 * VIEW_SCALE, text,
        function() self:setClockFormat(format) end)
    button.drawRectangle = false
    button.font = "SourceSansPro-Bold"
    button.textSize = getScaledFontSize(32)
    if format ~= clock24Hours then
        button.textColor = color(80)
    end
    self.formatButtons[format] = button
end

function ModifyRoutineState:setClockFormat(format)
    self.formatButtons[clock24Hours].textColor = color(80)
    clock24Hours = format
    saveLocalData("Routine_Clock24Hours", clock24Hours)
    self.formatButtons[clock24Hours].textColor = color(255)
end

function ModifyRoutineState:enter()
    analytics:view("modify")
        
    local size = 128 * VIEW_SCALE
    local height = 0.09 * HEIGHT
    local offset = 80 * VIEW_SCALE
    
    self.selectedClock = 0
    self.touchedClock = 0
    self.touchTotalDelta = 0
    self.movingClock = false
    
    if self.swappingClock ~= nil then
        self.selectedClock = self.swappingClock
        self.swappingClock = nil
    end
    
    self.tweakingDuration = false
    
    local size = 128 * VIEW_SCALE
        
    self.morningButton = AddSpriteButton(WIDTH / 2 - size - offset, height, size, size, 
        "Project:UI_Morning", function() self:selectRoutine(MORNING) end)
    self.morningButton.testFunc = function() return allRoutinesValid() end
    
    self.eveningButton = AddSpriteButton(WIDTH / 2 + offset, height, size, size, 
        "Project:UI_Evening", function() self:selectRoutine(EVENING) end)
    self.eveningButton.testFunc = function() return allRoutinesValid() end
    
    size = 64 * VIEW_SCALE
    self.startTimeButton = AddSpriteButton(10, HEIGHT / 2, size, size, 
        "Project:Alarm", function() self:setType(START_TIME) end)
    self.endTimeButton = AddSpriteButton(WIDTH - size - 10, HEIGHT / 2, size, size, 
        "Project:Bed", function() self:setType(END_TIME) end)
    
    self:selectRoutine(self.selectedRoutine)

    size = 96 * VIEW_SCALE
    local button = AddSpriteButton(WIDTH - size, 0, size, size, "Project:UI_Check", 
        function()
            saveRoutines()
            setState(MAIN_STATE)
        end)
    button.spriteScale = 0.8
    button.testFunc = function() return allRoutinesValid() end
    
    local button = AddSpriteButton(0, HEIGHT - size, size, size, "Project:UI_Information", 
        function()
            setState(CREDITS_STATE)
        end)
    button.spriteScale = 0.8

    size = 200 * VIEW_SCALE
    self.trash = AddSpriteButton(WIDTH - size, HEIGHT - size, size, size, "Project:UI_Trash")
    self.trash.spriteScale = 0.8
    self.trash.testFunc = function() return self.movingClock end
    
    self.swap = AddSpriteButton((WIDTH - size) / 2, (HEIGHT - size) / 2, size, size, "Project:UI_Swap")
    self.swap.spriteScale = 0.8
    self.swap.testFunc = function() return self.movingClock end

    self.formatButtons = {}
        
    self:addClockFormatButton(0, false, "12h")
    self:addClockFormatButton(1, true, "24h")
    
    self:updateTypeButtons()
end

function ModifyRoutineState:selectRoutine(routineIndex)
    if routineIndex == MORNING then
        self.morningButton.spriteTint = color(255, 255, 255, 255)
        self.eveningButton.spriteTint = color(80, 80, 80, 255)
    else
        self.eveningButton.spriteTint = color(255, 255, 255, 255)
        self.morningButton.spriteTint = color(80, 80, 80, 255)
    end
    self.selectedRoutine = routineIndex
    self.clocks = self.selectedRoutine == MORNING and morningRoutine or eveningRoutine
    self:updateTypeButtons()
end

function ModifyRoutineState:canAdd()
    return #self.clocks < 10
end

function ModifyRoutineState:draw()
    local numClocks = self:canAdd() and #self.clocks + 1 or #self.clocks
    local routineType = self.selectedRoutine == MORNING and morningType or eveningType
    local staticClock = routineType == START_TIME and 1 or #self.clocks
    local clockSize = getStepClockSize(numClocks)
    for i,v in ipairs(self.clocks) do
        local clockIndex = i
        if routineType == END_TIME and i == #self.clocks and self:canAdd() then
            clockIndex = clockIndex + 1
        end
        if not self.movingClock or self.touchedClock ~= i then
            local clockPosition = getClockPosition(clockIndex, numClocks)
            v:draw(clockPosition.x, clockPosition.y, clockSize, self.selectedRoutine,
                i ~= staticClock, false, true, false)
        end
    end
    if self:canAdd() then
        local clockSize = getStepClockSize(numClocks)
        local addIndex = routineType == START_TIME and numClocks or numClocks - 1
        addIndex = math.max(1, addIndex)
        local clockPosition = getClockPosition(addIndex, numClocks)
        self.addClock:draw(clockPosition.x, clockPosition.y, clockSize, self.selectedRoutine,
            false, false, false, false)
    end
    if self.selectedClock ~= 0 then
        local clock = self.clocks[self.selectedClock]
        mainClock.sprite = clock.sprite
        mainClock.duration = clock.duration
        mainClock.hour = clock.hour
        mainClock.min = clock.min
        local isStatic = self.selectedClock == staticClock
        mainClock:draw(0.5, 0.5, MAIN_CLOCK_SIZE, self.selectedRoutine, 
            not isStatic, not isStatic, isStatic, false)
    elseif not self.movingClock then
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
    end
    if self.movingClock then
        local moving = self.clocks[self.touchedClock]
        moving:drawAbsolute(currentTouch.x, currentTouch.y, clockSize, self.selectedRoutine, 
            true, false, true, false)
        
        textMode(CENTER)
        setFontSize(24)
        text(localization:get("Swap"), WIDTH/2, HEIGHT/2 - 115 * VIEW_SCALE)
    end
    local otherRoutine = getOtherRoutine(self.selectedRoutine)
    if not routineValid(self.selectedRoutine) then
        self:drawRoutineCondition(self.selectedRoutine)
    elseif not routineValid(otherRoutine) then
        self:drawRoutineCondition(otherRoutine)
    end
end

function ModifyRoutineState:drawRoutineCondition(routine)
    textMode(CENTER)
    setFontSize(28)
    fill(255, 0, 0)
    local line1
    local line2
    if routine == MORNING then
        line1 = localization:get("MorningCondition01")
        line2 = localization:get("MorningCondition02")
    else
        line1 = localization:get("EveningCondition01")
        line2 = localization:get("EveningCondition02")
    end
    text(line1, WIDTH / 2, 125 * VIEW_SCALE)
    text(line2, WIDTH / 2, 95 * VIEW_SCALE)
end

function ModifyRoutineState:setType(routineType)
    if self.selectedRoutine == MORNING then
        morningType = routineType
    else
        eveningType = routineType
    end
    self:updateTypeButtons()
end

function ModifyRoutineState:updateTypeButtons()
    local routineType = self.selectedRoutine == MORNING and morningType or eveningType
    if routineType == START_TIME then
        self.startTimeButton.spriteTint = color(255)
        self.endTimeButton.spriteTint = color(255, 255, 255, 125)
    else
        self.endTimeButton.spriteTint = color(255)
        self.startTimeButton.spriteTint = color(255, 255, 255, 125)
    end
end

function ModifyRoutineState:update()
    local routineType = self.selectedRoutine == morning and morningType or eveningType
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
            --self.selectedClock = closestIndex
            processRoutine(self.selectedRoutine)
        end
    end
end

function ModifyRoutineState:tweakDuration(touch)
    local routineType = self.selectedRoutine == MORNING and morningType or eveningType
    local staticClock = routineType == START_TIME and 1 or #self.clocks
    local clock = self.clocks[self.selectedClock]
    local dir = vec2(touch.x - mainClock.x, touch.y - mainClock.y)
    local angle = dir:angleBetween(vec2(0, 1))
    if angle < 0 then
        angle = angle + 2 * math.pi
    end
    local ratio = angle / (2 * math.pi)
    local minutes = math.ceil(ratio * 60)
    if minutes > 59 then
        minutes = 0
    end
    if minutes < 0 then
        minutes = 0
    end
    if staticClock == self.selectedClock then
        local diff = minutes - clock.min
        if math.abs(diff) < 30 then
            clock.min = clock.min + diff
        else
            if diff < 0 then
                diff = diff + 60
            else
                diff = diff - 60
            end
            clock.min = clock.min + diff
        end
        if clock.min > 59 then
            clock.hour = clock.hour + 1
            clock.min = clock.min - 60
        elseif clock.min < 0 then
            clock.hour = clock.hour - 1
            clock.min = clock.min + 60
        end
        if self.selectedRoutine == MORNING then
            if clock.hour >= 12 then clock.hour = clock.hour - 12 end
            if clock.hour < 0 then clock.hour = clock.hour + 12 end
            wakeUpHour = clock.hour
            wakeUpMinutes = clock.min
        else
            if clock.hour >= 24 then clock.hour = clock.hour - 12 end
            if clock.hour < 12 then clock.hour = clock.hour + 12 end
            bedTimeHour = clock.hour
            bedTimeMinutes = clock.min
        end
    else
        clock.duration = minutes
    end
    
    processRoutine(self.selectedRoutine)
end

function ModifyRoutineState:touched(touch)
    local touchedClock = false
    local routineType = self.selectedRoutine == MORNING and morningType or eveningType
    local staticClock = routineType == START_TIME and 1 or #self.clocks
    
    if self.tweakingDuration then
        if touch.state == MOVING then
            self:tweakDuration(touch)
        elseif touch.state == ENDED then
            self.tweakingDuration = false
        end
        return
    elseif self.touchedClock ~= 0 then
        if touch.state == MOVING then
            if not self.movingClock then
                local delta = math.abs(touch.deltaX) + math.abs(touch.deltaY)
                self.touchTotalDelta = self.touchTotalDelta + delta
                if self.touchTotalDelta >= DRAG_DELTA then
                    self.movingClock = true
                    self.selectedClock = 0
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
                if self.swap:isOver(touch) then
                    self.swap.spriteScale = 1.0
                    self.swap.spriteTint = color(255)
                else
                    self.swap.spriteScale = 0.8
                    self.swap.spriteTint = color(255, 255, 255, 125)
                end
            end
        elseif touch.state == ENDED then
            if self.trash:isOver(touch) then
                local action = self.selectedRoutine == MORNING and "del_morning" or "del_evening"
                local moving = self.clocks[self.touchedClock]
                analytics:event("clock", action, moving.sprite)                
                table.remove(self.clocks, self.touchedClock)
                processRoutine(self.selectedRoutine)
                self.selectedClock = 0
            elseif self.swap:isOver(touch) then
                self.swappingClock = self.touchedClock
                setState(SPRITE_SELECTION)
            else
                self.selectedClock = self.touchedClock
            end
            self.movingClock = false
            self.touchedClock = 0
        end
    end
    
    if self.movingClock then return end
    
    if touch.state ~= BEGAN then return end
        
    if self.selectedClock ~= 0 then
        if mainClock:isOver(touch) then
            touchedClock = true
            self.tweakingDuration = true
            self:tweakDuration(touch)
        end
    end

    if self:canAdd() and self.addClock:isOver(touch) then
        touchedClock = true
        setState(SPRITE_SELECTION)
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

function ModifyRoutineState:spriteSelected(spr)
    if self.swappingClock ~= nil then
        self.clocks[self.swappingClock].sprite = spr
        setState(MODIFY_ROUTINE_STATE)
        return
    end
    
    local action = self.selectedRoutine == MORNING and "add_morning" or "add_evening"
    analytics:event("clock", action, spr)
    local clock = Clock(15, spr, routine)
    local routineType = self.selectedRoutine == MORNING and morningType or eveningType
    local insertPos = routineType == START_TIME and #self.clocks + 1 or #self.clocks
    insertPos = math.max(insertPos, 1)
    table.insert(self.clocks, insertPos, clock)
    setState(MODIFY_ROUTINE_STATE)
    if not readLocalData("FirstClock", true) then
        self.selectedClock = insertPos        
    else
        saveLocalData("FirstClock", false)
    end
    processRoutine(self.selectedRoutine)
end
