
ResultState = Class{__includes = BaseState}

local rSelected = 1

function ResultState:enter(params)
    -- constants
    self.x = params.x
    self.y = params.y
    self.gravity = params.gravity

    -- results
    self.time = params.time
    self.velocity = math.floor((params.velocity * 100) + 0.5) / 100

end

function ResultState:update(dt)
    gStateback = true

    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        gSounds['change']:play()
        rSelected = rSelected == 1 and 2 or 1
    end

    if love.keyboard.wasPressed('return') then
        gSounds['blip']:play()

        if rSelected == 1 then
            gStateMachine:change('select')
        else
            love.event.quit()
        end
    end
end

function ResultState:render()
    love.graphics.draw(gTextures['lobby'], -backgroundX, 0)
    love.graphics.draw(gTextures['ground'], -groundX, VIRTUAL_HEIGHT - 16)

    love.graphics.setFont(gFonts['bigFont'])
    love.graphics.printf('CONSTANTS', 0, VIRTUAL_HEIGHT / 4 - 35, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('X: ' .. tostring(self.x / 4) .. 'm', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Y: ' .. tostring(72 - (self.y / 4)) .. 'm', 0, VIRTUAL_HEIGHT / 4 + 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('GRAVITY: ' .. tostring(self.gravity / 4) .. 'm/s', 0, VIRTUAL_HEIGHT / 4 + 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['bigFont'])
    love.graphics.printf('RESULTS', 0, VIRTUAL_HEIGHT / 4 + 26, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('TIME: ' .. tostring(self.time) .. 's', 0, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('FINAL VELOCITY: ' .. tostring(self.velocity) .. 'm/s', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

    if rSelected == 1 then
        love.graphics.setColor(255, 244, 78, 255)
    end

    love.graphics.printf('BACK TO SELECTION', 0, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT / 3), VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)

    if rSelected == 2 then
        love.graphics.setColor(255, 244, 78, 255)
    end

    love.graphics.printf('EXIT', 0, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT / 3 + 10), VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
end