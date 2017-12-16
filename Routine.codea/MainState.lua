MainState = class(State)

function MainState:init()
end

function MainState:enter()
    analytics:view("main")
    
    testing = false
    testingLastHour = 20
    
    firstFrame = true

    if not isNative() then
        parameter.clear()
        parameter.action("+15", function() offsetTime(15) end)
        parameter.action("-15", function() offsetTime(-15) end)
        parameter.action("Simulate", startSimulation)
        parameter.integer("TESTING_SPEED", 0, 60, 5)
        parameter.boolean("SHOW_STEPS", true)
        parameter.boolean("SHOW_TIME", true)
        parameter.boolean("FIXED_TIME", false)
    else
        SHOW_STEPS = true
        SHOW_TIME = true
        FIXED_TIME = false
    end

    self.gearSize = 96 * VIEW_SCALE
            
    button = AddSpriteButton(0, HEIGHT - self.gearSize, 
        self.gearSize, self.gearSize,
        "Project:UI_Profiles", function() setState(PROFILE_STATE) end)
    button.spriteScale = 0.7

        button = AddSpriteButton(WIDTH - self.gearSize, HEIGHT - self.gearSize, 
        self.gearSize, self.gearSize,
        "Project:UI_Gear", function() setState(MODIFY_ROUTINE_STATE) end)
    button.spriteScale = 0.7
    
    mainClock.hour = nil
    mainClock.min = nil
        
    processRoutines()
end

function changeDisplayMode()
    if displayMode() == FULLSCREEN_NO_BUTTONS then
        displayMode(STANDARD)
    else
        displayMode(FULLSCREEN_NO_BUTTONS)
    end
end

function currentTime()
    if testing then
        return { hour = testingHour, min = testingMin, sec = testingSec }
    else
        return currentDate
    end
end

function startSimulation()
    firstFrame = true

    testing = not testing
    
    if not testing then return end
    
    testingHour = wakeUpHour
    testingMin = wakeUpMinutes
    testingSec = 0
end

function getCurrentRoutine()
    local date = currentTime()
    return (date.hour < 12 and MORNING) or EVENING
end

function processRoutine(routineType)
    local timeType = routineType == MORNING and morningType or eveningType
    local routine = routineType == MORNING and morningRoutine or eveningRoutine
    if timeType == START_TIME then
        local currentHour = 0
        local currentMinutes = 0
        
        if routineType == EVENING then
            currentHour = bedTimeHour
            currentMinutes = bedTimeMinutes
            eveningStartHour = currentHour
            eveningStartMin = currentMinutes
        else
            currentHour = wakeUpHour
            currentMinutes = wakeUpMinutes
        end
        
        for i,v in ipairs(routine) do
            v.hour = currentHour
            v.min = currentMinutes
            if i ~= 1 then
                currentMinutes = currentMinutes + v.duration
            end
            if currentMinutes > 59 then
                currentHour = currentHour + 1
                currentMinutes = currentMinutes - 60
            end
            if i < #routine then
                v.next = routine[i+1]
            else
                v.next = nil
            end
        end    
        
        if routineType == MORNING then
            morningEndHour = currentHour
            morningEndMin = currentMinutes
        end
    else
        local currentHour = 0
        local currentMinutes = 0
        
        if routineType == MORNING then
            currentHour = wakeUpHour
            currentMinutes = wakeUpMinutes
            morningEndHour = currentHour
            morningEndMin = currentMinutes
        else
            currentHour = bedTimeHour
            currentMinutes = bedTimeMinutes
        end
        
        for i = #routine, 1, -1 do
            v = routine[i]
            if i ~= #routine then
                currentMinutes = currentMinutes - v.duration
            end
            if currentMinutes < 0 then
                currentHour = currentHour - 1
                currentMinutes = currentMinutes + 60
            end
            v.hour = currentHour
            v.min = currentMinutes
            if i < #routine then
                v.next = routine[i+1]
            else
                v.next = nil
            end
        end
        
        if routineType == EVENING then
            eveningStartHour = v.hour
            eveningStartMin = v.min
        end
    end
end

function processRoutines()
    processRoutine(MORNING)
    processRoutine(EVENING)
end

function routineValid(routine)
    if routine == MORNING then
        return morningEndHour < 12
    else
        return eveningStartHour >= 12
    end
end

function allRoutinesValid()
    return routineValid(MORNING) and routineValid(EVENING)
end

function getOtherRoutine(routine)
    return routine == MORNING and EVENING or MORNING
end

function offsetTime(minutes)
    local currentRoutine = getCurrentRoutine()
    local routine = (currentRoutine == MORNING) and morningRoutine or eveningRoutine
    for i, v in ipairs(routine) do
        v.min = v.min + minutes
        if v.min > 59 then
            v.hour = v.hour + 1
            v.min = v.min - 60
        end
        if v.min < 0 then
            v.hour = v.hour - 1
            v.min = v.min + 60
        end
    end
    
    firstFrame = true
end

function MainState:update()
    if testing then
        testingSec = testingSec + TESTING_SPEED
        if testingSec > 59 then
            testingSec = 0
            testingMin = testingMin + 1
            if testingMin > 59 then
                testingMin = 0
                testingHour = testingHour + 1
            end
            if testingHour >= bedTimeHour and testingMin >= bedTimeMinutes then
                testing = false
            end
            if testingHour >= morningEndHour and testingMin >= morningEndMin and
               testingHour < eveningStartHour and testingHour < eveningStartMin then
                testingHour = eveningStartHour
                testingMin = eveningStartMin
            end
        end
    end
end

function MainState:draw()
    strokeWidth(5)

    local date = currentTime()
    local currentRoutine = getCurrentRoutine()
    local clocks = (currentRoutine == MORNING) and morningRoutine or eveningRoutine
    
    local firstStarted = nil
    local clockSize = getStepClockSize(#clocks)
    if #clocks > 1 then
        for i,v in ipairs(clocks) do
            if firstStarted == nil and v:started() and v:valid() then
                firstStarted = v
            end
            if SHOW_STEPS then
                local clockPosition = getClockPosition(i, #clocks)
                v:draw(clockPosition.x, clockPosition.y, clockSize, currentRoutine,
                       true, false, true, false)
            end
        end
    end
    
    local minsLeft = nil
        
    if firstStarted ~= nil then
        if mainClock.sprite ~= firstStarted.sprite then
            mainClock.sprite = firstStarted.sprite
            if not firstFrame then
                sound("A Hero's Quest:Defensive Cast 1")
            end
        end
        if firstStarted.duration > 0 then
            local nextHour = firstStarted.next ~= nil and firstStarted.next.hour or morningEndHour
            local nextMin = firstStarted.next ~= nil and firstStarted.next.min or morningEndMin
            local totalMins = (nextHour - firstStarted.hour) * 60 + 
                (nextMin - firstStarted.min)
            local size = math.min(getWidth(), getHeight())
            local minsSpent = (date.hour - firstStarted.hour) * 60 +
                (date.min - firstStarted.min) + date.sec / 60
            minsLeft = totalMins - minsSpent
            if minsLeft > 0 then
                setFontSize(60)
                fill(255, 255, 255, 255)
                local message = math.ceil(minsLeft) .. " minute"
                if minsLeft > 1 then
                    message = message .. "s"
                end
                text(message, 0.5 * getWidth(), 0.07 * size)
            end
        end
    else
        mainClock.sprite = nil
    end
        
    if #clocks == 1 then
        setFontSize(40)
        local message = localization:get("TapToConfigure")
        local width = textSize(message)
        textMode(CENTER)
        text(message, WIDTH - 0.5 * width - self.gearSize, HEIGHT - 0.5 * self.gearSize)
    end
    
    if FIXED_TIME then
        mainClock.hour = bedTimeHour
        mainClock.min = bedTimeMinutes
    else
        mainClock.hour = nil
        mainClock.min = nil
    end
    
    mainClock.duration = minsLeft
    mainClock:draw(0.5, 0.5, MAIN_CLOCK_SIZE, currentRoutine, true, false, true, true)
    
    firstFrame = false    
end

function MainState:touched(touch)
    
end
