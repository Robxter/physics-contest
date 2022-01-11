--[[
    SELECT STATE FOR PHYSICS IN VIDEOGAME
    Author: Robxter

    2021 Robxter
]]

SelectState = Class{__includes = BaseState}

function SelectState:init()
    self.movable = true
end

function SelectState:update(dt)
    if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('right') then
        gSounds['change']:play()

        self.movable = self.movable == false and true or false
    end
    
    if love.keyboard.wasPressed('return') then
        gSounds['blip']:play()

        if self.movable then
            gStateMachine:change('movable')
        else
            gStateMachine:change('inamovable')
        end
    elseif love.keyboard.wasPressed('escape') then
        gSounds['hit']:play()

        gStateMachine:change('title')
    end
end

function SelectState:render()
    love.graphics.draw(gTextures['lobby'], -backgroundX, 0)
    love.graphics.draw(gTextures['ground'], -groundX, VIRTUAL_HEIGHT - 16)
    
    if self.movable == true then
        love.graphics.draw(gTextures['control'], VIRTUAL_WIDTH / 2 - 17,  VIRTUAL_HEIGHT / 2 - 10)
        love.graphics.printf('MOVIBLE', 0, VIRTUAL_HEIGHT / 2 + 25, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.draw(gTextures['locked'], VIRTUAL_WIDTH / 2 - 17, VIRTUAL_HEIGHT / 2 - 10)
        love.graphics.printf('INAMOVIBLE', 0, VIRTUAL_HEIGHT / 2 + 25, VIRTUAL_WIDTH, 'center')
    end

    -- left arrow
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 12, VIRTUAL_HEIGHT / 2 - 14)
    -- right arrow
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - (VIRTUAL_WIDTH / 4) - 12, VIRTUAL_HEIGHT / 2 - 14)
end