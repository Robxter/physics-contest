--[[
    Dependencies file for keeping that section of code outside of main
]]

push = require 'lib/push'

Class = require 'lib/class'

-- class for creating objects and have behavior based on it
require 'src/object'

-- library for useful external global functions
require 'src/Util'

-- library for creating states behavior
require 'lib/StateMachine'

require 'src/states/BaseState'
require 'src/states/TitleState'
require 'src/states/SelectState'
require 'src/states/Movable'
require 'src/states/Inamovable'
require 'src/states/PlayState'
require 'src/states/ResultState'
