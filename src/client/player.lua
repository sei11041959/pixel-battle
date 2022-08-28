local wf = require('lib.windfield')

Player = {}

function Player:load()
    self.x = 100
    self.y = 0
    self.width = 20
    self.height = 60
    self.xVel = 0
    self.yVel = 100
    self.maxspeed = 200
    self.acceleration = 4000
    self.friction = 3500

    self.physics = {}
    self.physics.body = world:newRectangleCollider(self.x,self.y,self.width,self.height)
    self.physics.body:setFixedRotation(true)
end


function Player:update(dt)
    self:syncPhysics()
end


function Player:syncPhysics()
    self.x,self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel , self.yVel)
end


function Player:draw()
    love.graphics.rectangle("fill",self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end