Paddle = Class{}


function Paddle:init(x, y, width, height)
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;
    self.dy = 0;
end

function Paddle:update(dt)

    if self.dy == 0 then
        return
    end

    if (self.dy < 0) then        
        self.y = self.y + -PADDLE_SPEED * dt
        if (self.y < 0) then
            self.y = 243
        end
    else 
        self.y = self.y + PADDLE_SPEED * dt
        if (self.y > 243) then
            self.y = 0
        end
    end
end

function Paddle:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end