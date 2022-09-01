CountdownState = Class{__includes = BaseState};

function CountdownState:init()
    self.actualCountdown = 3;
    self.timer = 0;
end

function CountdownState:update(dt)
    self.timer = self.timer + dt;
    if self.timer > 1 then
        self.actualCountdown = self.actualCountdown - 1;
        self.timer = 0
    end

    if self.actualCountdown == 0 then
        gStateMachine:change('play');
    end
end

function CountdownState:render()
    love.graphics.setFont(flappyFont);
    love.graphics.printf(tostring(self.actualCountdown), 0, 64, VIRTUAL_WIDTH, 'center');
end