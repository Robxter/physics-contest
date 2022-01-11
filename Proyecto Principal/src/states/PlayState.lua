
PlayState = Class{__includes = BaseState}

local resultsY = 0
local timer = 0

-- constants
local time = 0
local gravity = 40
local velocity = 0

local menu = 1

function PlayState:enter(params)
    -- params variables for object creation
    self.movable = params.movable
    self.movement = params.movement
    self.multiplier = params.multiplier or 1
    self.image = params.image

    -- constants for passing it to result
    self.x = VIRTUAL_WIDTH / 2 - self.image:getWidth()
    self.y = VIRTUAL_HEIGHT / 2 - self.image:getHeight()

    self.dy = 0

    -- flags
    self.objPaused = self.movable == false and true or false
    self.finish = false
    self.launch = false
    self.paused = false
    
    -- tables
    self.objects = {}

    table.insert(self.objects, object(self.image, false,        -- image or rectangle
        self.x,                                                 -- x
        self.y,                                                 -- y
        self.image:getWidth(),                                  -- width
        self.image:getHeight(),                                 -- height
        self.movable,                                           -- movable
        self.movement,                                          -- mode
        self.multiplier,                                        -- velocity multiplier
        gravity
    ))
end

function PlayState:update(dt)
    local timer = 0

    if self.finish == false then
        if self.paused == false then
            object.dy = self.dy

            for k, object in pairs(self.objects) do
                if self.movable == false then
                    if love.keyboard.wasPressed('space') then
                        self.objPaused = false
                        self.launch = true
    
                        resultsY = object.y
                    end
                end

                if self.movement == 'free fall' then
                    if love.keyboard.isDown('up') then
                        -- make sure to don't get past higher than the top edge of the screen
                        object.y = math.max(0, object.y - 4)
                    elseif love.keyboard.isDown('down') then
                        -- same as before but down sense
                        object.y = math.min(VIRTUAL_HEIGHT - object.height, object.y + 4)
                    end

                    if love.keyboard.isDown('w') then
                        object.gravity = object.gravity + 4
                    elseif love.keyboard.isDown('s') then
                        object.gravity = object.gravity - 4
                    end
                elseif self.movement == 'parabolic throw' then
                    object.y = object.y
                end

                if self.launch == true then
                    self.dy = self.dy + object.gravity * dt

                    time = math.floor((time + dt * 100) + 0.5) / 100

                    if object.y >= VIRTUAL_HEIGHT - object.height then
                        gSounds['hit']:play()
                        object.y = VIRTUAL_HEIGHT - object.height
                            
                        timer = timer + dt

                        self.objPaused = true
                        self.launch = false
                        self.finish = true

                        velocity = object.dy / 4
                        timer = 0
                    end
                    
                end

                if self.objPaused == false then
                    object:update(dt)
                end
            end
            

            if love.keyboard.wasPressed('escape') then
                gSounds['blip']:play()
                self.paused = true
            end
        -- pause menu
        else
            if love.keyboard.wasPressed('escape') then
                gSounds['change']:play()
                self.paused = false
            end

            if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
                gSounds['hit']:play()
            elseif love.keyboard.wasPressed('return') then
                gSounds['blip']:play()
                gStateMachine:change('select')
            end
        end
    else
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            gSounds['change']:play()
            menu = menu == 1 and 2 or 1
        end

        if love.keyboard.wasPressed('return') then
            gSounds['blip']:play()

            if menu == 1 then
                gStateMachine:change('results', {
                    x = self.x,
                    y = resultsY,
                    gravity = gravity,
                    time = time,
                    velocity = velocity
                })
            else
                self.y = VIRTUAL_HEIGHT / 2 - self.image:getHeight()
                gravity = 40
                time = 0
                velocity = 0

                self.finish = false
                self.objPaused = true
            end
        end
    end

    if timer >= 0.1 then
        self.dy = 0
    end
end

function PlayState:render()

    if self.movement == 'god' then
        love.graphics.draw(gTextures['sky'], 0, 0)
    elseif self.movement == 'mario' then
        love.graphics.draw(gTextures['lobby'], 0, 0)
        love.graphics.draw(gTextures['ground'], 0, VIRTUAL_HEIGHT - 16)
    else
        love.graphics.draw(gTextures['lobby'], 0, 0)
        love.graphics.draw(gTextures['ground'], 0, VIRTUAL_HEIGHT - 16)
    end

    love.graphics.setFont(gFonts['medium'])

    for k, object in pairs(self.objects) do
        object:render()

        love.graphics.printf('Gravedad: ' .. tostring(object.gravity / 4) .. 'm/s', 0, VIRTUAL_HEIGHT / 4 - 10, VIRTUAL_WIDTH, 'right')
        love.graphics.printf('X: ' .. tostring(object.x / 4) .. 'm', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'right')

        if self.launch == false and self.finish == false then
            love.graphics.printf('Y: ' .. tostring(72 - (object.y / 4)) .. 'm', 0, VIRTUAL_HEIGHT / 4 + 10, VIRTUAL_WIDTH, 'right')
        else
            love.graphics.printf('Y: ' .. tostring(resultsY / 4) .. 'm', 0, VIRTUAL_HEIGHT / 4 + 10, VIRTUAL_WIDTH, 'right')
        end
    end

    love.graphics.setFont(gFonts['bigFont'])
    if self.paused then
        love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(255, 244, 78, 255)
        love.graphics.printf('EXIT', 0, VIRTUAL_HEIGHT / 2 - 7, VIRTUAL_WIDTH, 'center')
    elseif self.finish then
        if menu == 1 then
            love.graphics.setColor(255, 244, 78, 255)
        end
        love.graphics.printf('SEE RESULTS', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)

        if menu == 2 then
            love.graphics.setColor(255, 244, 78, 255)
        end

        love.graphics.printf('RESET TEST', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)

    end

    love.graphics.setColor(255, 255, 255, 255)
end