Class = require 'class';

require 'Paddle';
require 'Ball';

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- speed at which we will move our paddle; multiplied by dt in update
PADDLE_SPEED = 400

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()

    math.randomseed(os.time())
      
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('PONG')

    -- more "retro-looking" font object we can use for any text
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- larger font for drawing the score on the screen
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- set LÖVE2D's active font to the smallFont obect
    love.graphics.setFont(smallFont)

    -- initialize window with virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- initialize score variables, used for rendering on the screen and keeping
    -- track of the winner
    player1Score = 0
    player2Score = 0

    -- paddle positions on the Y axis (they can only move up or down)
    player1 = Paddle(10, 30, 5, 20); 
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20);

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4);

    gameState = 'start';
end

--[[
    Runs every frame, with "dt" passed in, our delta in seconds 
    since the last frame, which LÖVE2D supplies us.
]]
function love.update(dt)

    if gameState == 'play' then
        if (ball:collides(player1)) then
            ball.dx = -ball.dx * 1.03;
            ball.x = player1.x + 5;
            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- detect upper and lower screen boundary collision and reverse if collided
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        -- -4 to account for the ball's size
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end

        if ball.x <= 0 then
            player2Score = player2Score + 1;
            gameState = 'start';
            ball:reset();

        end
        if ball.x >= VIRTUAL_WIDTH - 4 then
            player1Score = player1Score + 1;
            gameState = 'start';
            ball:reset();
        end

    end

    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player1.dy = -PADDLE_SPEED;
    elseif love.keyboard.isDown('s') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player1.dy = PADDLE_SPEED; 
    else 
        player1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player2.dy = -PADDLE_SPEED;
    elseif love.keyboard.isDown('down') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player2.dy = PADDLE_SPEED;
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt);
    player2:update(dt);
end

--[[
    Keyboard handling, called by LÖVE2D each frame; 
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)
    -- keys can be accessed by string name
    if key == 'escape' then
        -- function LÖVE gives us to terminate application
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then 
            gameState = 'play';
        else 
            gameState = 'start';
            ball:reset();
        end
    end
end

--[[
    Called after update by LÖVE2D, used to draw anything to the screen, 
    updated or otherwise.
]]
function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- clear the screen with a specific color; in this case, a color similar
    -- to some versions of the original Pong
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- draw welcome text toward the top of the screen
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)

    -- render first paddle (left side), now using the players' Y variable

    player1:render();
    player2:render();

    ball:render();

    displayFPS();
    -- end rendering at virtual resolution
    push:apply('end')
end


function displayFPS()
    love.graphics.setFont(smallFont);
    love.graphics.setColor(0,255,0, 255);
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end