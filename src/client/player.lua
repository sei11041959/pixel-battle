local wf = require('lib.windfield')

Player = {}

function Player:load()
    self.x = love.graphics.getWidth() / 2
    self.y = 0
    self.width = 20
    self.height = 100
    self.speed = 300
    self.xVel = 0
    self.yVel = 0

    self.pm = 3
    self.maxspeed = 200 * self.pm
    self.acceleration = 4000 * self.pm
    self.friction = 3500 * self.pm
    self.gravity = 2000
    self.jumpamount = -800
    self.grounded = false
    self.ceiling = false

    self.physics = {}
    self.physics.body = world:newRectangleCollider(self.x,self.y,self.width,self.height)
    self.physics.body:setCollisionClass('Player')
    self.physics.body:setFixedRotation(true)
    self.physics.fixtures = self.physics.body:getFixtures()
end


function Player:update(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
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

function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function Player:beginContact(a, b , collision)
    if self.grounded == true then return end
    local nx ,ny = collision:getNormal()
    for i, fixture in ipairs(self.physics.fixtures) do
        if a == fixture then
            if ny < 0 then
                self:onGround(collision)
            elseif ny == 1 then
                self:nonGround(collision)
            end
        elseif b == fixture then
            if ny < 0 then
                self:onGround(collision)
            elseif ny == 1 then
                self:nonGround(collision)
            end
        end
    end
end


function Player:endContact(a, b , collision)
    for i, fixture in ipairs(self.physics.fixtures) do
        local nx ,ny = collision:getNormal()
        if a == fixture then
            if self.currentGroundCollision == collision then
                self.grounded = false
            end
        end
        if b == fixture then
            if self.currentGroundCollision == collision then
                self.grounded = false
            end
        end
    end
end

function Player:onGround(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
end

function Player:nonGround(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = false
end

function Player:jump(key)
    if (key == "w" or key == "up" or key == "space") and self.grounded == true then
        self.yVel = self.jumpamount
        self.grounded = false
    end
end

function Player:syncPhysics()
    self.x,self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel , self.yVel)
end