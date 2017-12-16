SwipeHelper = class()

SwipeLeft = 0
SwipeRight = 1
SwipeUp = 2
SwipeDown = 3

function SwipeHelper:init(in_handler)
    self.handler = in_handler
    self.currentTouchId = -1
    self.touchStartTime = -1
    self.waitForRelease = false
    
    self.repeatSwipe = false
    self.repeatDelay = 0.5
end

function SwipeHelper:touched(touch)
    if touch.state == BEGAN then
        if self.currentTouchId == -1 then
            self.currentTouchId = touch.id
            self.touchStartTime = ElapsedTime
            self.touchStartPos = vec2(touch.x, touch.y)
        end
    elseif touch.state == MOVING then
        if not self.waitForRelease and self.currentTouchId == touch.id then
            touchEndPos = vec2(touch.x, touch.y)
            touchDiff = touchEndPos - self.touchStartPos
            absX = math.abs(touchDiff.x)
            touchLen = touchDiff:len()
            absY = math.abs(touchDiff.y)
            if absX > 30 and absY < absX then
                self.waitForRelease = true
                if touchDiff.x > 0 then
                    self.handler:swipe(self.touchStartPos, SwipeRight, 1, 0)
                    self.lastPos = self.touchStartPos
                    self.lastDir = SwipeRight
                    self.lastX = 1
                    self.lastY = 0
                else
                    self.handler:swipe(self.touchStartPos, SwipeLeft, -1, 0)
                    self.lastPos = self.touchStartPos
                    self.lastDir = SwipeLeft
                    self.lastX = -1
                    self.lastY = 0
                end
                self.nextRepeat = self.repeatDelay
            elseif absX < absY and absY > 30 then
                self.waitForRelease = true
                if touchDiff.y > 0 then
                    self.handler:swipe(self.touchStartPos, SwipeUp, 0, 1)
                    self.lastPos = self.touchStartPos
                    self.lastDir = SwipeUp
                    self.lastX = 0
                    self.lastY = 1
                else
                    self.handler:swipe(self.touchStartPos, SwipeDown, 0, -1)
                    self.lastPos = self.touchStartPos
                    self.lastDir = SwipeDown
                    self.lastX = 0
                    self.lastY = -1
                end
                self.nextRepeat = self.repeatDelay
            end
        end
    elseif touch.state == ENDED then
        if self.currentTouchId == touch.id then
            if not self.waitForRelease then
                duration = ElapsedTime - self.touchStartTime
                if duration < 0.2 and self.handler ~= nil then
                    self.handler:tap(self.touchStartPos)
                end
            end
            self.waitForRelease = false
            self.currentTouchId = -1
        end
    end
end

function SwipeHelper:update()
    if self.repeatSwipe and self.waitForRelease then
        self.nextRepeat = self.nextRepeat - 0.01667
        if self.nextRepeat <= 0 then
            self.handler:swipe(self.lastPos, self.lastDir, self.lastX, self.lastY)
            self.nextRepeat = self.nextRepeat + self.repeatDelay 
        end
    end
end
