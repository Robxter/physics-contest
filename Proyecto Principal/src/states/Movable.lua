
Movable = Class{__includes = BaseState}

local m = true

function Movable:init()
    self.movable = true
    self.movement = nil
    self.multiplier = nil
    self.image = nil
end

function Movable:update(dt)
    if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('right') then
        gSounds['change']:play()
        m = m == false and true or false
    end

    if m then
        self.movement = 'god'
        self.multiplier = 3
        self.image = gTextures['bird']
    else
        self.movement = 'mario'
        self.multiplier = 2
        self.image = gTextures['mario']
    end

    if love.keyboard.wasPressed('return') and m ~= 2 then
        gSounds['blip']:play()
        gStateback = false
        
        gStateMachine:change('play', {
            movable = self.movable,
            movement = self.movement,
            multiplier = self.multiplier,
            image = self.image
        })
    elseif love.keyboard.wasPressed('escape') then
        gSounds['hit']:play()
        gStateMachine:change('select')
    end
end

function Movable:render()
    -- background rendering
    love.graphics.draw(gTextures['lobby'], -backgroundX, 0)
    love.graphics.draw(gTextures['ground'], -groundX, VIRTUAL_HEIGHT - 16)

    -- selecting render
    if m then
        love.graphics.draw(gTextures['bird'], VIRTUAL_WIDTH / 2 - 19, VIRTUAL_HEIGHT / 2 - 12)
        love.graphics.printf('Bird', 0, VIRTUAL_HEIGHT / 2 + 25, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.draw(gTextures['mario'], VIRTUAL_WIDTH / 2 - 15, VIRTUAL_HEIGHT / 2 - 14)
        love.graphics.printf('Mario', 0, VIRTUAL_HEIGHT / 2 + 25, VIRTUAL_WIDTH, 'center')
    end

    -- arrows render
    -- left arrow
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 12, VIRTUAL_HEIGHT / 2 - 14)
    -- right arrow
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - (VIRTUAL_WIDTH / 4) - 12, VIRTUAL_HEIGHT / 2 - 14)
end