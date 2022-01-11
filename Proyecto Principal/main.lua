--[[
    VIDEOGAME PHYSICS 2022 for Concurso interno aplicado de fisica
    V 1.5

    AUTHOR: Cristian Roberto Teran Paredes
]]


require 'src/Dependencies'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

backgroundX, groundX = 0, 0
gStateback = true

function love.load()
    -- set nearest for sharp edges rendering
    love.graphics.setDefaultFilter('nearest', 'nearest')


    gTextures = {
        ['mario'] = love.graphics.newImage('textures/mario.png'),
        ['sonic'] = love.graphics.newImage('textures/sonicF.png'),
        ['red'] = love.graphics.newImage('textures/red.png'),
        ['bird'] = love.graphics.newImage('textures/bird.png'),
        ['character'] = love.graphics.newImage('textures/character.png'),
        ['arrows'] = love.graphics.newImage('textures/arrows.png'),
        ['control'] = love.graphics.newImage('textures/controller.png'),
        ['locked'] = love.graphics.newImage('textures/locked.png'),
        ['fireball'] = love.graphics.newImage('textures/fireball.png'),
        ['meteor'] = love.graphics.newImage('textures/meteor.png'),
        ['ball'] = love.graphics.newImage('textures/ball.png'),
        ['clouds'] = love.graphics.newImage('textures/clouds.png'),
        ['ground'] = love.graphics.newImage('textures/ground.png'),
        ['lobby'] = love.graphics.newImage('textures/background.png'),
        ['sky'] = love.graphics.newImage('textures/sky.png')
    }

    gSounds = {
        ['blip'] = love.audio.newSource('sounds/blip.wav', 'static'),
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['change'] = love.audio.newSource('sounds/change.wav', 'static'),

        -- music
        ['music'] = love.audio.newSource('sounds/mario.mp3', 'static')
    }

    gFrames = {
        ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
        ['cloud'] = GenerateQuads(gTextures['clouds'], 48, 96)
    }

    gFonts = {
        ['game'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 30),
        ['bigFont'] = love.graphics.newFont('fonts/font.ttf', 40),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 15),
        ['small'] = love.graphics.newFont('fonts/font.ttf', 7)
    }

    gStateMachine = StateMachine{
        ['title'] = function() return TitleState() end,
        ['select'] = function() return SelectState() end,
        ['movable'] = function() return Movable() end,
        ['inamovable'] = function() return Inamovable() end,
        ['play'] = function() return PlayState() end,
        ['results'] = function() return ResultState() end
    }

    love.window.setTitle('Fisica en Videojuegos2D')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        rezisable = false,
        fullscreen = false,
        vsync = true
    })

    love.keyboard.keysPressed = {}

    gCollisions = setupGlobalCollisions() -- not working and useless for now - 12/28/21

    gStateMachine:change('title')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    
    gStateMachine:update(dt)
    
    if gStateback then
        backgroundX = (backgroundX + 20 * dt) % 413 -- the modulo value is the looping point
        groundX = (groundX + 50 * dt) % VIRTUAL_WIDTH
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
        gStateMachine:render()
    push:finish()
end