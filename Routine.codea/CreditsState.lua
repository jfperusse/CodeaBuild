CreditsState = class(State)

function CreditsState:init()
    self.flatIconUrl = "https://www.flaticon.com"
    self.flatIconAuthorUrl = "https://www.flaticon.com/authors/"
    self.flatIconFreeUrl = "https://www.flaticon.com/free-icon/"
    
    self.lines = {}
        
    table.insert(self.lines, { size = 56, text = localization:get("DesignProg") })
    
    table.insert(self.lines, { size = 40, text = "Jean-François Pérusse" })
    
    table.insert(self.lines, { size = 48 })
        
    table.insert(self.lines, { size = 56, text = localization:get("CreatedWith") })
    
    table.insert(self.lines, { spr = "Project:UI_Codea",
                               link = "http://itunes.apple.com/app/id439571171?mt=8" })
    
    table.insert(self.lines, { size = 40, text = localization:get("CodeaForIPad") })
    
    table.insert(self.lines, { size = 48 })

    table.insert(self.lines, { size = 56, text = "Art" })
    
    table.insert(self.lines, { spr = "Project:Alarm", 
                               author = "Pixel Buddha", 
                               link = "pixel-buddha",
                               iconUrl = "alarm-clock_179504" })
    
    table.insert(self.lines, { spr = "Project:Apple", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "apple_564986" })
    
    table.insert(self.lines, { spr = "Project:Backpack", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "backpack_167725" })
    
    table.insert(self.lines, { spr = "Project:Bath", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "bathtub_593652" })
    
    table.insert(self.lines, { spr = "Project:Bed", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "sleep_565006" })

    table.insert(self.lines, { spr = "Project:Bed02", 
                               author = "Nikita Golubev", 
                               link = "nikita-golubev",
                               iconUrl = "bed_362426" })
    
    table.insert(self.lines, { spr = "Project:Blueberries", 
                               author = "Smashicons", 
                               link = "smashicons",
                               iconUrl = "blueberries_135587" })
    
    table.insert(self.lines, { spr = "Project:Book", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "open-book_167755" })

    table.insert(self.lines, { spr = "Project:Car", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "car_171239" })
    
    table.insert(self.lines, { spr = "Project:Carrot", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "carrot_591329" })
    
    table.insert(self.lines, { spr = "Project:Cereals", 
                               author = "Smashicons", 
                               link = "smashicons",
                               iconUrl = "cereals_135670" })

    table.insert(self.lines, { spr = "Project:Comb", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "hair-comb_547983" })

    table.insert(self.lines, { spr = "Project:Controller", 
                               author = "Pixel Buddha", 
                               link = "pixel-buddha",
                               iconUrl = "gamepad_214304" })

    table.insert(self.lines, { spr = "Project:Dress", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "dress_170705" })

    table.insert(self.lines, { spr = "Project:EggBacon", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "breakfast_168525" })
    
    table.insert(self.lines, { spr = "Project:HandWash", 
                               author = "Smashicons", 
                               link = "smashicons",
                               iconUrl = "hygienic_237594" })

    table.insert(self.lines, { spr = "Project:Home", 
                               author = "Vectors Market", 
                               link = "vectors-market",
                               iconUrl = "house_598568" })

    table.insert(self.lines, { spr = "Project:Homework", 
                               author = "Dimitry Miroliubov", 
                               link = "dimitry-miroliubov",
                               iconUrl = "book_509692" })
    
    table.insert(self.lines, { spr = "Project:Hoodie", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "hoodie_570663" })
    
    table.insert(self.lines, { spr = "Project:Horse", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "rocking-horse_501584" })
    
    table.insert(self.lines, { spr = "Project:Milk", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "milk_288503" })
        
    table.insert(self.lines, { spr = "Project:Moon", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "night_565016" })

    table.insert(self.lines, { spr = "Project:MusicNotes", 
                               author = "Pixel Buddha", 
                               link = "pixel-buddha",
                               iconUrl = "quaver_179593" })
    
    table.insert(self.lines, { spr = "Project:Pajamas", 
                               author = "Roundicons", 
                               link = "roundicons",
                               iconUrl = "pijamas_190215" })
    
    table.insert(self.lines, { spr = "Project:Pajamas02", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "pajamas_164647" })
    
    table.insert(self.lines, { spr = "Project:Puzzle", 
                               author = "DinosoftLabs", 
                               link = "dinosoftlabs",
                               iconUrl = "puzzle_438941" })
    
    table.insert(self.lines, { spr = "Project:Shoes", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "footwear_289008" })

    table.insert(self.lines, { spr = "Project:Spaghetti", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "spaghetti_325562" })
        
    table.insert(self.lines, { spr = "Project:TV", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "monitor_124092" })

    table.insert(self.lines, { spr = "Project:Toilet", 
                               author = "Creaticca Creative Agency", 
                               link = "creaticca-creative-agency",
                               iconUrl = "toilet_456526" })
    
    table.insert(self.lines, { spr = "Project:Toothbrush02", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "toothbrush_129701" })
    
    table.insert(self.lines, { spr = "Project:UI_Add", 
                               author = "Roundicons", 
                               link = "roundicons",
                               iconUrl = "add_189755" })
    
    table.insert(self.lines, { spr = "Project:UI_Check", 
                               author = "Roundicons", 
                               link = "roundicons",
                               iconUrl = "checked_189763" })
    
    table.insert(self.lines, { spr = "Project:UI_Evening", 
                               author = "Smashicons", 
                               link = "smashicons",
                               iconUrl = "moon_136767" })
    
    table.insert(self.lines, { spr = "Project:UI_Gear", 
                               author = "Vectors Market", 
                               link = "vectors-market",
                               iconUrl = "time_610239" })

    table.insert(self.lines, { spr = "Project:UI_Information", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "info_221753" })

    table.insert(self.lines, { spr = "Project:UI_Morning", 
                               author = "Smashicons", 
                               link = "smashicons",
                               iconUrl = "sunrise_136741" })
    
    table.insert(self.lines, { spr = "Project:UI_Remove", 
                               author = "Roundicons", 
                               link = "roundicons",
                               iconUrl = "cancel_189758" })
    
    table.insert(self.lines, { spr = "Project:UI_Tools", 
                               author = "Smashicons", 
                               link = "smashicons",
                               iconUrl = "tools_222600" })
    
    table.insert(self.lines, { spr = "Project:UI_Trash", 
                               author = "Smashicons", 
                               link = "smashicons",
                               iconUrl = "trash_230366" })
    
    table.insert(self.lines, { spr = "Project:Yoga", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "mat_565013" })

    table.insert(self.lines, { spr = "Project:Shirt", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "clothes_614672" })

    table.insert(self.lines, { spr = "Project:Pajamas03", 
                               author = "Freepik", 
                               link = "freepik",
                               iconUrl = "pajamas_164648" })
end

function CreditsState:enter()
    analytics:view("credits")
        
    self.spriteSize = 128 * VIEW_SCALE
    self.margin = 40 * VIEW_SCALE
    self.attribSize = 32
    
    buttons = {}
    
    local size = 128 * VIEW_SCALE
    local button = AddSpriteButton(
        WIDTH - size, HEIGHT - size,  size, size, "Project:UI_Remove",
        function() setState(MODIFY_ROUTINE_STATE) end)
    button.spriteScale = 0.8
    
    self.y = 0.0
end

function CreditsState:update()
    local speed = (waitForRelease or currentTouch.state == ENDED) and 100 or 300
    self.y = self.y + speed * DeltaTime
end

function CreditsState:addLink(x, y, w, h, link)
    table.insert(self.links, { x = x, y = y, w = w, h = h, link = link })
end

function CreditsState:draw()
    local currentY = self.y
    
    local rendered = false
    
    self.links = {}
    
    spriteMode(CENTER)
    
    fill(255)
    
    for i, v in ipairs(self.lines) do
        if v.text ~= nil then
            if currentY > (-v.size * VIEW_SCALE) and 
               currentY < (HEIGHT + v.size * VIEW_SCALE) then
                rendered = true
                setFontSize(v.size)
                textMode(CENTER)
                text(v.text, WIDTH / 2, currentY)
            end
            currentY = currentY - v.size - self.margin
        elseif v.spr ~= nil then
            if currentY > (-self.spriteSize) and currentY < (HEIGHT + self.spriteSize) then
                rendered = true
                local x = WIDTH / 2
                local y = currentY - 0.5 * self.spriteSize
                sprite(v.spr, x, y, self.spriteSize, self.spriteSize)
                if v.author ~= nil then
                    self:addLink(x, y, self.spriteSize, self.spriteSize,
                                 self.flatIconFreeUrl .. v.iconUrl)
                elseif v.link ~= nil then
                    self:addLink(x, y, self.spriteSize, self.spriteSize,
                                 v.link)
                end
            end
            currentY = currentY - 1.3 * self.spriteSize
            if v.author ~= nil then
                if currentY > (-self.attribSize * VIEW_SCALE) and 
                   currentY < (HEIGHT + self.attribSize * VIEW_SCALE) then
                    rendered = true
                    setFontSize(self.attribSize)
                    textMode(CORNER)
                    local iconBy = localization:get("IconBy")
                    local from = localization:get("From")
                    local size1, h = textSize(iconBy)
                    local size2 = textSize(v.author)
                    local size3 = textSize(from)
                    local size4 = textSize("www.flaticon.com")
                    local w = size1 + size2 + size3 + size4
                    local x = WIDTH / 2 - 0.5 * w
                    local y = currentY - 0.5 * h
                    fill(255)
                    text(iconBy, x, y)
                    x = x + size1
                    fill(0, 124, 255, 255)
                    text(v.author, x, y)
                    self:addLink(x + 0.5 * size2, y + 0.5 * h, size2, h,
                                self.flatIconAuthorUrl .. v.link)
                    x = x + size2
                    fill(255)
                    text(from, x, y)
                    x = x + size3
                    fill(0, 124, 255, 255)
                    text("www.flaticon.com", x, y)                
                    self:addLink(x + 0.5 * size4, y + 0.5 * h, size4, h, self.flatIconUrl)
                    fill(255)
                end
                currentY = currentY - 2 * self.margin
            end
        elseif v.size ~= nil then
            if currentY > (-v.size * VIEW_SCALE) and 
               currentY < (HEIGHT + v.size * VIEW_SCALE) then
                rendered = true
            end
            currentY = currentY - v.size * VIEW_SCALE - self.margin
        end
    end
    
    setFontSize(24)
    textMode(CORNER)
    local w = textSize(fullVersion)
    fill(100)
    text(fullVersion, WIDTH - w, 0)
    fill(255)
    
    if not rendered then
        setState(MODIFY_ROUTINE_STATE)
    end
end

function CreditsState:touched(touch)
    if touch.state == BEGAN then
        for i, v in ipairs(self.links) do
            if touch.x >= (v.x - 0.5 * v.w) and touch.x <= (v.x + 0.5 * v.w) and
               touch.y >= (v.y - 0.5 * v.h) and touch.y <= (v.y + 0.5 * v.h) then
                openURL(v.link)
                return
            end
        end
    end
end