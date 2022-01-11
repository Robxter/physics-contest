
Inamovable = Class{__includes = BaseState}

local b = true

function Inamovable:init()
    self.movable = false
    self.movement = nil
    self.image = gTextures['ball']
end

function Inamovable:update(dt)

    if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('right') then
        gSounds['change']:play()

        b = b == false and true or false
    end

    if b then
        self.movement = 'free fall'
    else
        self.movement = 'parabolic throw'
    end

    if love.keyboard.wasPressed('return') and b then
        gSounds['blip']:play()
        gStateback = false

        gStateMachine:change('play', {
            movable = self.movable,
            movement = self.movement,
            image = self.image
        })
    elseif love.keyboard.wasPressed('escape') then
        gSounds['hit']:play()
        gStateMachine:change('select')
    end
end

function Inamovable:render()
    -- background rendering
    love.graphics.draw(gTextures['lobby'], -backgroundX, 0)
    love.graphics.draw(gTextures['ground'], -groundX, VIRTUAL_HEIGHT - 16)

    -- selecting render
    if b then
        love.graphics.draw(gTextures['fireball'], VIRTUAL_WIDTH / 2 - 16, VIRTUAL_HEIGHT / 2 - 23)
        love.graphics.printf('Caida Libre', 0, VIRTUAL_HEIGHT / 2 + 25, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.draw(gTextures['meteor'], VIRTUAL_WIDTH / 2 - 16, VIRTUAL_HEIGHT / 2 - 16)
        love.graphics.printf('NO DISPONIBLE', 0, VIRTUAL_HEIGHT / 2 + 25, VIRTUAL_WIDTH, 'center')
    end

    -- arrows render
    -- left arrow
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 12, VIRTUAL_HEIGHT / 2 - 14)
    -- right arrow
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - (VIRTUAL_WIDTH / 4) - 12, VIRTUAL_HEIGHT / 2 - 14)
end