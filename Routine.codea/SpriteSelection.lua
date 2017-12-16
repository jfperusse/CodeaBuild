SpriteSelection = class(State)

function SpriteSelection:init()
    self.assetList = sprites
end

function SpriteSelection:enter()
    analytics:view("sprite")
        
    buttons = {}

    local removeSize = 96 * VIEW_SCALE
    local columns = 8
    local rows = math.ceil(#self.assetList / columns)
    local size = WIDTH / columns
    local verticalOffset = 0.5 * rows * size - size
    local centerHeight = (HEIGHT / 2 - 0.5 * removeSize)
    for i,v in ipairs(self.assetList) do
        local column = (i - 1) % columns
        local row = math.floor((i - 1) / columns)
        local spr = "Project:" .. v
        local button = AddSpriteButton(
            column * size, centerHeight + verticalOffset - row * size, size, size, spr,
            function() ModifyRoutineState.Instance():spriteSelected(spr) end)
        button.spriteScale = 0.6
    end
    
    local button = AddSpriteButton(
        WIDTH - removeSize, HEIGHT - removeSize,  removeSize, removeSize, "Project:UI_Remove",
        function() setState(MODIFY_ROUTINE_STATE) end)
    button.spriteScale = 0.8
end

function SpriteSelection:update()
    
end

function SpriteSelection:draw()
end

function SpriteSelection:touched(touch)
end
