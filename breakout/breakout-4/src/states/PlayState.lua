PlayState = Class{__includes = BaseState};

function PlayState:init()
    self.paddle = Paddle();
    self.ball = Ball(math.random(7));

    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 42

    self.bricks = LevelMaker.createMap();
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false;
            gSounds['pause']:play()
        else
            return;
        end
    
    elseif love.keyboard.wasPressed('space') then
        self.paused = true;
        gSounds['pause']:play();
        return;
    end

    self.paddle:update(dt);
    self.ball:update(dt);

    if (self.ball:collides(self.paddle)) then
        self.ball.y = self.paddle.y - 8
        self.ball.dy = -self.ball.dy;

        --
        -- tweak angle of bounce based on where it hits the paddle
        --

        -- if we hit the paddle on its left side while moving left...
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
        
            -- else if we hit the paddle on its right side while moving right...
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end


        gSounds['paddle-hit']:play();
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            brick:hit();
                        --
            -- collision code for bricks
            --
            -- we check to see if the opposite side of our velocity is outside of the brick;
            -- if it is, we trigger a collision on that side. else we're within the X + width of
            -- the brick and should check to see if the top or bottom edge is outside of the brick,
            -- colliding on the top or bottom accordingly 
            --

            -- left edge; only check if we're moving right
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                
                -- flip x velocity and reset position outside of brick
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - 8
            
            -- right edge; only check if we're moving left
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                
                -- flip x velocity and reset position outside of brick
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32
            
            -- top edge if no X collisions, always check
            elseif self.ball.y < brick.y then
                
                -- flip y velocity and reset position outside of brick
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
            
            -- bottom edge if no X collisions or top collision, last possibility
            else
                
                -- flip y velocity and reset position outside of brick
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end

            -- slightly scale the y velocity to speed up the game
            self.ball.dy = self.ball.dy * 1.02

            -- only allow colliding with one brick, for corners
            break
        end
    end


    if love.keyboard.wasPressed('escape') then
        love.event.quit();
    end
end

function PlayState:render()

    for k, brick in pairs(self.bricks) do
        brick:render();
    end
    
    self.paddle:render();
    self.ball:render();

    if self.paused then
        love.graphics.setFont(gFonts['large']);
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end