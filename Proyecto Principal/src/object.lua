--[[
    OBJECT CLASS for Gravity Simulator V1
    Author: Robxter

]]

-- Declaring this file as Class
object = Class{}

-- const value
local VELOCITY = 100

function object:init(img, rectangle, x, y, width, height, movable, mode, multiplier, gravity)
    -- object optional image
    self.image = img or nil
    
    self.width = self.image == nil and width or math.floor(self.image:getWidth())
    self.height = self.image == nil and height or math.floor(self.image:getHeight())

    self.mode = mode or 'free fall'

    self.x = x
    self.y = self.mode == 'mario' and VIRTUAL_HEIGHT - (self.height) or y

    self.dx = 0
    self.dy = 0
    self.gravity = gravity or 40
    self.vmultiplier = multiplier or 1

    -- flags
    self.movable = movable or false
    self.rectangle = rectangle or false
end

function object:update(dt)
    if self.movable then
        -- mode that allow user to move like fly in the X and Y axis without limitations
        if self.mode == 'god' then
            -- X Axis Movement
            -- left movement
            if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
                self.dx = self.dx + (VELOCITY * self.vmultiplier) * dt 
                self.x = math.max(0, self.x - self.dx)


            -- right movement
            elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
                self.dx = self.dx + (VELOCITY * self.vmultiplier) * dt
                self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx)
            end

            -- Y Axis Movement
            if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
                self.dy = self.dy + (VELOCITY * self.vmultiplier) * dt
                self.y = math.max(0, self.y - self.dy)
            elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
                self.dy = self.dy + (VELOCITY * self.vmultiplier) * dt
                self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy)
            end

            self.dy = 0
        
        -- "mario's" movement
        elseif self.mode == 'mario' then
            -- X Movements
            -- left movement
            if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
                self.dx = self.dx + (VELOCITY * self.vmultiplier) * dt
                self.x = math.max(0, self.x - self.dx)
            -- right movement
            elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
                self.dx = self.dx + (VELOCITY * self.vmultiplier) * dt
                self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx)
            end

            if love.keyboard.isDown('space') and self.y == VIRTUAL_HEIGHT - (self.height + 16) then
                gSounds['jump']:play()
                self.dy = -750
            end

            self.dy = self.dy + self.gravity
            self.y = self.y + self.dy * dt

            -- if we've gone below the map limit, set DY to 0
            if self.y > VIRTUAL_HEIGHT - (self.height + 16) then
                self.y = VIRTUAL_HEIGHT - (self.height + 16)
                self.dy = 0
            end
        end
        -- reset all delta X values for not flushing the velocity of movement each frame passed
        self.dx = 0
    else
        if self.mode == 'free fall' or 'caida libre' then
            self.dy = self.dy + (self.gravity * self.vmultiplier) * dt
            self.y = self.y  + self.dy
        -- elseif self.mode == 'parabolic throw' or 'tiro parabolico' then
        
        end    
    end
end

function object:render()
    if self.rectangle then
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    elseif self.image ~= nil then
       love.graphics.draw(self.image, self.x, self.y)
    end

    love.graphics.printf(tostring(self.y), 0, 10, VIRTUAL_WIDTH, 'center')
end
