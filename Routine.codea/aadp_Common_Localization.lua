Localization = class()

function Localization:init(in_defaultLanguage)
    if in_defaultLanguage ~= nil then
        self.defaultLanguage = in_defaultLanguage
    else
        self.defaultLanguage = "en"
    end
    self.language = readLocalData("currentLanguage", self.defaultLanguage)
    local prevDevice = readLocalData("deviceLanguage", self.defaultLanguage)
    local device = prevDevice
    if isNative() then
        device = native.getDeviceLanguage()
    end
    if self.language == prevDevice and prevDevice ~= device then
        self.language = device
    end
    saveLocalData("currentLanguage", self.language)
    saveLocalData("deviceLanguage", device)
end

function Localization:setLanguage(in_language)
    self.language = in_language
    saveLocalData("currentLanguage", self.language)
end

function Localization:missingKey(in_key)
    return "{" .. in_key .. "}"
end

function Localization:get(in_key, in_array)
    local strings = in_array
    if in_array == nil then
        strings = localizedStrings
    end
    
    if strings == nil then
        return self:missingKey(in_key)
    end
    
    languageToUse = self.language
    
    if strings[self.language] == nil or
       strings[self.language][in_key] == nil then
        if self.language ~= self.defaultLanguage then
            languageToUse = self.defaultLanguage
        else
            return self:missingKey(in_key)
        end
    end
    
    if strings[languageToUse][in_key] == nil then
        return self:missingKey(in_key)
    end
    
    return strings[languageToUse][in_key]
end
