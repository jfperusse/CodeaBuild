Clock = class()

MORNING = 1
EVENING = 2

function addClock(routine, duration, spr)
    local routineList = routine == MORNING and morningRoutine or eveningRoutine
    local clock = Clock(duration, spr, routine)
    table.insert(routineList, clock)
    return clock
end

function addStepClock(routine, duration, spr)
    local routineList = routine == MORNING and morningRoutine or eveningRoutine
    addClock(routine, duration, spr)
end

function Clock:init(duration, spr)
    self.duration = duration
    self.sprite = spr
    self.spriteScale = 0.5
    self.showNumbers = true
end

function Clock:drawLine(angle, length, width, cx, cy, col)
    local lx = math.sin(angle) * length + cx
    local ly = math.cos(angle) * length + cy
    lineCapMode(PROJECT)
    stroke(col)
    strokeWidth(width)
    line(cx, cy, lx, ly)
end

function Clock:started()
    local date = currentTime()
    return date.hour > self.hour or (date.hour == self.hour and date.min >= self.min)
end

function Clock:valid()
    return
        self.hour == nil or
        not self:started() or
        self.next == nil or
        not self.next:started()    
end

function Clock.getScreenX(relativeX)
    local offset = 0
    if getWidth() > getHeight() then
        local maxSize = math.max(getWidth(), getHeight())
        offset = (maxSize - VIEW_SIZE) / 2
    end
    return offset + relativeX * VIEW_SIZE + 0.5 * (WIDTH - getWidth())    
end

function Clock.getScreenY(relativeY)
    local offset = 0
    if getWidth() <= getHeight() then
        local maxSize = math.max(getWidth(), getHeight())
        offset = (maxSize - VIEW_SIZE) / 2
    end
    return offset + relativeY * VIEW_SIZE + 0.5 * (HEIGHT - getHeight())    
end

function Clock:calcScreenX(relativeX)
    self.x = Clock.getScreenX(relativeX)
    return self.x
end

function Clock:calcScreenY(relativeY)
    self.y = Clock.getScreenY(relativeY)
    return self.y
end

function Clock:calcScreenRadius(relativeRadius)
    self.radius = relativeRadius * VIEW_SIZE
    return self.radius
end

function Clock:draw(relativeX, relativeY, relativeRadius, routine,
                    showTimer, showDuration, showHands, showSeconds)
    local x = self:calcScreenX(relativeX)
    local y = self:calcScreenY(relativeY)

    self:drawAbsolute(x, y, relativeRadius, routine,
                      showTimer, showDuration, showHands, showSeconds)   
end

function Clock:drawAbsolute(x, y, relativeRadius, routine,
                            showTimer, showDuration, showHands, showSeconds)
    local foregroundColor = (routine == MORNING) and DARK_COLOR or LIGHT_COLOR
    local backgroundColor = (routine == MORNING) and LIGHT_COLOR or DARK_COLOR
    
    local r = self:calcScreenRadius(relativeRadius)
    local d = 2 * r
    local sw = 0.03 * r
    
    if CLOCK_EDGE then        
        stroke(foregroundColor)
        strokeWidth(sw)
    else
        noStroke()
    end
        
    fill(backgroundColor)
    ellipseMode(CENTER)
    ellipse(x, y, d)
    
    local min = self.min
    local hour = self.hour
    local date = currentTime()
    if min == nil or hour == nil then
        sec = currentSeconds
        min = date.min + (date.sec / 60)
        hour = date.hour
    else
        sec = 0
    end
    
    local digitalSuffix = " AM"
    
    if not clock24Hours and hour > 12 then
        hour = hour - 12
        digitalSuffix = " PM"
    end
    
    hour = hour + (min / 60)

    local minutesAngle = (min / 30) * math.pi
    local hoursAngle = (hour / 6) * math.pi
    local secsAngle = (sec / 30) * math.pi
    
    local timeTimerMins = nil
    if showTimer then
        if self.duration ~= nil and self.duration < 60 then
            timeTimerMins = self.duration
        end
    end
        
    if self.sprite ~= nil then
        local size = self.spriteScale * d
        sprite(self.sprite, x, y, size, size)
        -- Hack to fix the seams on sprite edges
        if self.spriteScale < 0.8 then
            rectMode(CENTER)
            noFill()
            strokeWidth(2)
            stroke(backgroundColor)
            rect(x, y, size + 2, size + 2)
        end
    end
    
    if timeTimerMins ~= nil and timeTimerMins > 0 and timeTimerMins < 60 then
        local minsLeftAngle = (timeTimerMins / 30) * math.pi
        local timeTimerSize = 0.85 * d - 2 * sw
        local timerOffset = minutesAngle + minsLeftAngle
        if showHands then
            rotation = math.rad(-90) - timerOffset
        else
            rotation = math.rad(-90) - minsLeftAngle
        end
        timeTimer:setRect(1, x, y, timeTimerSize, timeTimerSize, rotation)
        timeTimer.shader.a1 = math.rad(-180)
        local a2 = -180 + (360 * (timeTimerMins / 60))
        timeTimer.shader.a2 = math.rad(a2)
        timeTimer:draw()
    end
        
    textMode(CENTER)
    fill(foregroundColor)
    
    setFontSize(17 * (relativeRadius / 0.1))
    
    if self.showNumbers then
        for i = 1, 12 do
            local angle = (i / 6) * math.pi
            local tx = math.sin(angle) * 0.8 * r + x
            local ty = math.cos(angle) * 0.8 * r + y
            text(i, tx, ty)
        end
    end
    
    if showHands then
        self:drawLine(minutesAngle, 0.8 * r, 0.045 * r, x, y, foregroundColor)
        self:drawLine(hoursAngle, 0.5 * r, 0.045 * r, x, y, foregroundColor)
        if showSeconds then
            self:drawLine(secsAngle, 0.85 * r, 0.03 * r, x, y, color(255, 50, 50))
        end
        noStroke()
        fill(foregroundColor)
        ellipse(x, y, 0.06 * d)
        fill(backgroundColor)
        ellipse(x, y, 0.03 * d)
    end
    
    fill(255)
    
    if isMainState() and not self:valid() then
        noStroke()
        fill(0, 0, 0, 200)
        ellipseMode(CENTER)
        ellipse(x, y, d)        
        fill(255, 255, 255, 75)
    end
    
    if SHOW_TIME then
        if showDuration then
            --local digital = "0:" .. string.format("%02d", math.floor(self.duration))
            local digital = math.floor(self.duration) .. "m"
            text(digital, x, y - 1.15 * r)
        elseif self.showNumbers then
            local digital = math.floor(hour) .. ":" .. string.format("%02d", math.floor(min))
            if not clock24Hours then
                digital = digital .. digitalSuffix
            end
            text(digital, x, y - 1.15 * r)
        end
    end
    
    if self.name ~= nil then
        textAlign(CENTER)
        if self.wrapWidth ~= nil then
            textWrapWidth(self.wrapWidth * d)
        end
        textMode(CORNER)
        local w, h = textSize(self.name)
        text(self.name, x - 0.5 * w, y - 1 * r - h)
        if self.wrapWidth ~= nil then
            textWrapWidth(0)
        end
    end
end

function Clock:isOver(touch)
    if self.x == nil or self.y == nil then return false end
    local distX = touch.x - self.x
    local distY = touch.y - self.y
    local radius = self.radius
    local distSq = distX * distX + distY * distY
    return distSq <= radius * radius
end
