Class = require 'lib/class'

push = require 'lib/push'

-- used for timers and tweening
Timer = require 'lib/knife.timer'

-- utility
require 'src/StateMachine'
require 'src/Util'

-- game pieces
require 'src/Board'
require 'src/Tile'

-- -- game states
require 'src/states/BaseState'
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/StartState'

gSounds = {
    ['music'] = love.audio.newSource('sounds/match-3_music3.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/match-3_sounds_select.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/match-3_sounds_error.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match-3_sounds_match.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/match-3_sounds_clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/match-3_sounds_game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/match-3_sounds_next-level.wav', 'static')
}

gTextures = {
    ['main'] = love.graphics.newImage('graphics/match3.png'),
    ['background'] = love.graphics.newImage('graphics/background.png')
}

gFrames = {
    
    -- divided into sets for each tile type in this game, instead of one large
    -- table of Quads
    ['tiles'] = GenerateTileQuads(gTextures['main'])
}

-- this time, we're keeping our fonts in a global table for readability
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}
