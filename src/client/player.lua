local wf = require('lib.windfield')

Player = {}

function Player:load()
    self.x = 0
    self.y = 0
    self.width = 20
    self.height = 60
    self.speed = 100
    self.xVel = 0
    self.yVel = 200
    self.maxspeed = 500
    self.acceleration = 4000
    self.friction = 4000

    self.physics = {}
    self.physics.body = world:newRectangleCollider(self.x,self.y,self.width,self.height)
    self.physics.body:setFixedRotation(true)
end


function Player:update(dt)
    self:syncPhysics()
    self:move(dt)
end


function Player:draw()
    love.graphics.rectangle("fill",self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end


function Player:move(dt)
    if love.keyboard.isDown("d","right") then
        if self.xVel < self.maxspeed then
            if self.xVel + self.acceleration * dt < self.maxspeed then
                self.xVel = self.xVel + self.acceleration * dt
            else
                self.xVel = self.maxspeed
            end
        end
    elseif love.keyboard.isDown("a","left") then
        if self.xVel >  -self.maxspeed then
            if self.xVel - self.acceleration * dt > -self.maxspeed then
                self.xVel = self.xVel - self.acceleration * dt
            else
                self.xVel = -self.maxspeed
            end
        end
    else
        self:applyFriction(dt)
    end
end


function Player:applyFriction(dt)
    if self.xVel > 0 then
        if self.xVel - self.friction * dt > 0 then
           self.xVel = self.xVel - self.friction * dt
        else
           self.xVel = 0
        end
     elseif self.xVel < 0 then
        if self.xVel + self.friction * dt < 0 then
           self.xVel = self.xVel + self.friction * dt
        else
           self.xVel = 0
        end
     end
end


function Player:syncPhysics()
    self.x,self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel , self.yVel)
end