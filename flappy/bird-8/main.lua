

Class = require 'class';
push = require 'push';

require 'Bird';
require 'Pipe';
require 'PipePair';

require 'StateMachine';
require 'states/BaseState';
require 'states/PlayState';
require 'states/TitleScreenState';


WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

VIRTUAL_WIDTH = 512;
VIRTUAL_HEIGHT = 288;

local background = love.graphics.newImage('background.png');
local backgroundScroll = 0;
local ground = love.graphics.newImage('ground.png');
local groundScroll = 0;

local BACKGROUND_SCROLL_SPEED = 30;
local GROUND_SCROLL_SPEED = 60;


local BACKGROUND_LOOPING_POINT = 413;

local bird = Bird()

local pipePairs = {};
local spawnTimer = 0;

local lastY = -PIPE_HEIGHT + math.random(80) + 20;


local scrolling = true;

function love.load()
    
    love.graphics.setDefaultFilter('nearest', 'nearest');
    math.randomseed(os.time())

    love.window.setTitle('fifty bird');

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)

    love.graphics.setFont(flappyFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    });


    gStateMachine = StateMachine {
        ['title'] = function () return TitleScreenState() end,
        ['play'] = function () return PlayState() end
    }

    gStateMachine:change('title');

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h);
end

function love.update(dt)
    
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT;
    groundScroll =  (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH;

    gStateMachine:update(dt);
    
    love.keyboard.keysPressed = {}
end


function love.keypressed(key)
    
    love.keyboard.keysPressed[key] = true;

    if key == 'escape' then
        love.event.quit();
    end
    
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true;
    else
        return false;
    end
end


function love.draw()

    push:start()

    love.graphics.draw(background, -backgroundScroll, 0);
    gStateMachine:render();
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16);
    push:finish()
    
end