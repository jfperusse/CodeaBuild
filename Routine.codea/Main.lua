-- Routine

supportedOrientations(LANDSCAPE_ANY)
displayMode(FULLSCREEN_NO_BUTTONS)

MAIN_STATE = 1
MODIFY_ROUTINE_STATE = 2
SPRITE_SELECTION = 3
CREDITS_STATE = 4
PROFILE_STATE = 5

START_TIME = 1
END_TIME = 2

function setup()
    initializing = false
    
    analytics = Analytics("UA-109289469-1", "Routine")
    
    if isNative() then
        fullVersion = native.getBundleVersion() .. " (" .. native.getBuildVersion() .. ")"
    else
        fullVersion = "1.0 (1)"
    end
    
    waitForRelease = false
        
    localization = Localization("en")

    font("SourceSansPro-Bold")
            
    states = { 
        MainState(),
        ModifyRoutineState(),
        SpriteSelection(),
        CreditsState(),
        ProfileState(),
    }
    
    clock24Hours = readLocalData("Routine_Clock24Hours", false)

    timeTimer = mesh()
    timeTimer:addRect(0, 0, 1, 1)
    timeTimer.shader = shader("Patterns:Arc")
    timeTimer.shader.size = 0
    timeTimer.shader.color = color(255, 0, 0, 150)
    
    initializing = true
    
    setGlobalParameters()
    
    initializing = false
    
    currentDate = os.date("*t")
    currentSeconds = currentDate.sec
    
    setupView()

    createClocks()

    setState(MAIN_STATE)
end

function saveSpritesList()
    local result = "sprites = {\n"
    local assets = assetList("Project", SPRITES)
    for i, v in ipairs(assets) do
        result = result .. '"' .. v .. '",\n'
    end
    result = result .. "}"
    saveProjectTab("SpritesList", result)    
end

function loadRoutine(routineType, prefix)
    local count = readLocalData(prefix .. "Count")
    if routineType == MORNING then
        wakeUpHour = readLocalData(prefix .. "Hour", 0)
        wakeUpMinutes = readLocalData(prefix .. "Minutes", 0)
        morningType = readLocalData(prefix .. "Type", START_TIME)
    else
        bedTimeHour = readLocalData(prefix .. "Hour", 0)
        bedTimeMinutes = readLocalData(prefix .. "Minutes", 0)
        eveningType = readLocalData(prefix .. "Type", END_TIME)
    end
    for i = 1, count do
        local duration = readLocalData(prefix .. "Duration" .. i, 0)
        local spr = readLocalData(prefix .. "Sprite" .. i, "")
        addStepClock(routineType, duration, spr)
    end
end

function saveRoutine(routineType, prefix)
    local routine = (routineType == MORNING) and morningRoutine or eveningRoutine
    local count = #routine
    saveLocalData(prefix .. "Count", count)
    if routineType == MORNING then
        saveLocalData(prefix .. "Hour", wakeUpHour)
        saveLocalData(prefix .. "Minutes", wakeUpMinutes)
        saveLocalData(prefix .. "Type", morningType)
    else
        saveLocalData(prefix .. "Hour", bedTimeHour)
        saveLocalData(prefix .. "Minutes", bedTimeMinutes)
        saveLocalData(prefix .. "Type", eveningType)
    end    
    for i, v in ipairs(routine) do
        saveLocalData(prefix .. "Duration" ..i, v.duration)
        saveLocalData(prefix .. "Sprite" ..i, v.sprite)
    end
end

function saveRoutines()
    saveRoutine(MORNING, "Morning_")
    saveRoutine(EVENING, "Evening_")
end

function createClocks()
    if initializing then return end
    
    morningRoutine = {}
    eveningRoutine = {}
    
    routines = {morningRoutine, eveningRoutine}
    
    mainClock = Clock()
    
    local morningCount = readLocalData("Morning_Count", -1)
    if morningCount == -1 then
        wakeUpHour = 7
        wakeUpMinutes = 0
        
        bedTimeHour = 20
        bedTimeMinutes = 0
        
        addStepClock(MORNING,  0, "Project:Alarm")
        addStepClock(EVENING,  0, "Project:Bed")
    else
        loadRoutine(MORNING, "Morning_")
        loadRoutine(EVENING, "Evening_")
    end
end

function loadClockBackup() 
    morningRoutine = {}
    eveningRoutine = {}
    
    routines = {morningRoutine, eveningRoutine}
        
    wakeUpHour = 7
    wakeUpMinutes = 0
    
    bedTimeHour = 20
    bedTimeMinutes = 30

    addStepClock(MORNING,  0, "Project:Alarm")
    addStepClock(MORNING, 15, "Project:Toilet")
    addStepClock(MORNING, 15, "Project:Dress")                
    addStepClock(MORNING, 30, "Project:Cereals")
    addStepClock(MORNING, 10, "Project:Toothbrush02")
    addStepClock(MORNING,  5, "Project:Shoes")

    addStepClock(EVENING, 30, "Project:Spaghetti")
    addStepClock(EVENING, 20, "Project:Bath")
    addStepClock(EVENING, 10, "Project:Pajamas02")
    addStepClock(EVENING, 20, "Project:Blueberries")
    addStepClock(EVENING, 10, "Project:Toothbrush02")
    addStepClock(EVENING, 20, "Project:Book")
    addStepClock(EVENING, 10, "Project:Toilet")
    addStepClock(EVENING,  0, "Project:Bed")
    
    processRoutines()
end

function getClockPosition(index, count)
    local clockOffset = getStepClockOffset(count)
    local startAngle = -(count - 1) * clockOffset * 0.5
    local angle = startAngle + (index - 1) * clockOffset
    return { x = math.sin(angle) * 0.4 + 0.5, y = math.cos(angle) * 0.4 + 0.5 }
end

function setState(stateIndex)
    local initialState = true
    
    if currentState ~= nil then
        currentState:exit()
        initialState = false
    end
    
    currentState = states[stateIndex]
    
    parameter.clear()
    buttons = {}
    
    initializing = true

    currentState:enter()
    currentStateIndex = stateIndex
    
    setGlobalParameters()
    
    setGlobalButtons()
    
    initializing = false
    
    if not initialState then
        waitForRelease = true
    end
end

function isMainState()
    return currentStateIndex == MAIN_STATE
end

function isModifyState()
    return currentStateIndex == MODIFY_ROUTINE_STATE
end

function setGlobalParameters()
    if not isNative() then
        parameter.color("LIGHT_COLOR", color(255))
        parameter.color("DARK_COLOR", color(0))
        parameter.action("Amelie", function() loadClockBackup() end)
        parameter.number("VIEW_ZOOM", 0.1, 3, 1, setupView)
        parameter.number("MAIN_CLOCK_SIZE", 0, 0.4, 0.23)
        parameter.color("BACKGROUND", color(40, 40, 50))
        parameter.boolean("CLOCK_EDGE", true)
        parameter.text("OLD_NAME", "")
        parameter.text("NEW_NAME", "")
        parameter.action("Rename Asset", function() renameAsset() end)
    else
        VIEW_ZOOM = 1
        MAIN_CLOCK_SIZE = 0.23
        BACKGROUND = color(40, 40, 50)
        CLOCK_EDGE = true
        LIGHT_COLOR = color(255)
        DARK_COLOR = color(0)        
    end
end

function setGlobalButtons()

end

function getStepClockOffset(count)
    if count > 8 then
        return 0.459
    else
        return 0.543
    end
end

function getStepClockSize(count)
    if count > 8 then
        return 0.076
    else
        return 0.09
    end
end

function setupView()
    if initializing then return end
    
    VIEW_SIZE = math.min(WIDTH, HEIGHT) * VIEW_ZOOM
    VIEW_SCALE = VIEW_SIZE / 768
end

function getWidth()
    return WIDTH * VIEW_ZOOM
end

function getHeight()
    return HEIGHT * VIEW_ZOOM
end

function getScaledFontSize(size)
    local ratio = VIEW_SIZE / 768
    return size * VIEW_SCALE
end

function setFontSize(size)
    fontSize(getScaledFontSize(size))
end

function renameAsset()
    local oldName = "Project:" .. OLD_NAME
    local newName = "Project:" .. NEW_NAME
    local asset = readImage(oldName)
    saveImage(newName, asset)
    saveImage(oldName, nil)
    
    OLD_NAME = ""
    NEW_NAME = ""
    
    sprite()
end

function update()
    currentSeconds = currentSeconds + DeltaTime
    if currentSeconds >= 60 then currentSeconds = currentSeconds - 60 end
    currentDate = os.date("*t")
    local diffSeconds = math.abs(currentSeconds - currentDate.sec)
    if diffSeconds > 30 then diffSeconds = 60 - diffSeconds end
    if diffSeconds > 1 then
        currentSeconds = currentDate.sec
    end
    
    if currentTouch == nil then
        currentTouch = CurrentTouch
    end
    
    if waitForRelease and currentTouch.state == ENDED then
        waitForRelease = false
    end

    currentState:update()
end

currentTouchId = nil
currentTouch = nil

function touched(touch)
    if currentTouchId ~= nil and touch.id ~= currentTouchId then
        return
    end
    
    if touch.state ~= ENDED then
        currentTouchId = touch.id
    else
        currentTouchId = nil
    end
    
    currentTouch = touch
    
    currentState:touched(touch)

    if waitForRelease then
        return
    end
    
    if not isNative() then
        if currentTouch.state == BEGAN and currentTouch.tapCount == 5 then
            changeDisplayMode()
            waitForRelease = true
        end
    end

    for i,v in ipairs(buttons) do
        v:touched(touch)
    end    
end

function drawButtons()
    setFontSize(32)
    
    for i,v in ipairs(buttons) do
        v:draw()
    end
end

function draw()
    update()
    
    background(BACKGROUND)

    drawButtons()

    currentState:draw()
end
