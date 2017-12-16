PerfTimer = class()

testValue = 0

local osclock = os.clock

function PerfTimer:init(in_name, in_paused)
    self.name = in_name
    self.running = in_paused == nil or not in_paused
    self.total = 0
    self.startTime = osclock()
end

function PerfTimer:pause()
    local clock = osclock()
    if self.running then
        local delta = clock - self.startTime
        self.total = self.total + delta
        self.running = false
        return self.total
    end
    return self.total
end

function PerfTimer:stop()
    return self:pause()
end

function PerfTimer:pauseAndPrint()
    self:pause()
    self:print()
    return self.total
end

function PerfTimer:print()
    if self.total > 1 then
        print(self.name .. ' : ' .. string.format("%.3f s", self.total))
    else
        print(self.name .. ' : ' .. string.format("%.3f ms", self.total * 1000))
    end
end

function PerfTimer:reset()
    self.running = false
    self.total = 0
    self.startTime = osclock()
end

function PerfTimer:restart(in_name)
    self.name = in_name
    self.running = true
    self.total = 0
    self.startTime = osclock()
end

function PerfTimer:start()
    self.running = true
    self.startTime = osclock()
end

function PerfTimer:resume()
    self.running = true
    self.startTime = osclock()
end
