MusicAddon = class()

function MusicAddon:init(in_filename)
    self.selfName = tostring(self)
    
    if MusicAddon_load ~= nil then
        MusicAddon_load(self.selfName, in_filename)
    end
end

function MusicAddon:load(in_filename)
    if MusicAddon_load ~= nil then
        MusicAddon_load(self.selfName, in_filename)
    end
end

function MusicAddon:unload()
    if MusicAddon_unload ~= nil then
        MusicAddon_unload(self.selfName)
    end
end

function MusicAddon:getURL()
    if MusicAddon_getURl ~= nil then
        return MusicAddon_getURL(self.selfName)
    end

    return ""
end

function MusicAddon:enableRate()
    if MusicAddon_enableRate ~= nil then
        MusicAddon_enableRate(self.selfName)
    end
end

function MusicAddon:enableMetering()
    if MusicAddon_enableMetering ~= nil then
        MusicAddon_enableMetering(self.selfName)
    end
end

function MusicAddon:prepareToPlay()
    if MusicAddon_prepareToPlay ~= nil then
        MusicAddon_prepareToPlay(self.selfName)
    end
end

function MusicAddon:getLoops()
    if MusicAddon_getLoops ~= nil then
        return MusicAddon_getLoops(self.selfName)
    end
    
    return 0
end

function MusicAddon:setLoops(in_loops)
    if MusicAddon_setLoops ~= nil then
        MusicAddon_setLoops(self.selfName, in_loops)
    end
end

function MusicAddon:getPan()
    if MusicAddon_getPan ~= nil then
        return MusicAddon_getPan(self.selfName)
    end
    
    return 0
end

function MusicAddon:setPan(in_pan)
    if MusicAddon_setPan ~= nil then
        MusicAddon_setPan(self.selfName, in_pan)
    end
end

function MusicAddon:getRate()
    if MusicAddon_getRate ~= nil then
        return MusicAddon_getRate(self.selfName)
    end
    
    return 1.0
end

function MusicAddon:setRate(in_rate)
    if MusicAddon_setRate ~= nil then
        MusicAddon_setRate(self.selfName, in_rate)
    end
end

function MusicAddon:play()
    if MusicAddon_play ~= nil then
        MusicAddon_play(self.selfName)
    end
end

function MusicAddon:playAfterDelay(in_delay)
    if MusicAddon_playAfterDelay ~= nil then
        MusicAddon_playAfterDelay(self.selfName, in_delay)
    end
end

function MusicAddon:pause()
    if MusicAddon_pause ~= nil then
        MusicAddon_pause(self.selfName)
    end
end

function MusicAddon:stop()
    if MusicAddon_stop ~= nil then
        MusicAddon_stop(self.selfName)
    end
end

function MusicAddon:isPlaying()
    if MusicAddon_isPlaying ~= nil then
        return MusicAddon_isPlaying(self.selfName)
    end
    
    return false
end

function MusicAddon:getCurrentTime()
    if MusicAddon_getCurrentTime ~= nil then
        return MusicAddon_getCurrentTime(self.selfName)
    end
    
    return 0.0
end

function MusicAddon:setCurrentTime(in_time)
    if MusicAddon_setCurrentTime ~= nil then
        MusicAddon_setCurrentTime(self.selfName, in_time)
    end
end

function MusicAddon:getDuration()
    if MusicAddon_getDuration ~= nil then
        return MusicAddon_getDuration(self.selfName)
    end
    
    return 0.0
end

function MusicAddon:getNumberOfChannels()
    if MusicAddon_getNumberOfChannels ~= nil then
        return MusicAddon_getNumberOfChannels(self.selfName)
    end
    
    return 0
end

function MusicAddon:getVolume()
    if MusicAddon_getVolume ~= nil then
        return MusicAddon_getVolume(self.selfName)
    end
    
    return 0.0
end

function MusicAddon:setVolume(in_volume)
    if MusicAddon_setVolume ~= nil then
        MusicAddon_setVolume(self.selfName, in_volume)
    end
end

function MusicAddon:getAveragePowerForChannel(in_channel)
    if MusicAddon_getAveragePowerForChannel ~= nil then
        return MusicAddon_getAveragePowerForChannel(self.selfName, in_channel)
    end
    
    return -160.0
end

function MusicAddon:getPeakPowerForChannel(in_channel)
    if MusicAddon_getPeakPowerForChannel ~= nil then
        return MusicAddon_getPeakPowerForChannel(self.selfName, in_channel)
    end
    
    return -160.0
end