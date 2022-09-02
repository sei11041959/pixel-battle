local wf = require('lib.windfield')

Player = {}

function Player:load()
    self.x = love.graphics.getWidth() / 2
    self.y = 0
    self.width = 20
    self.height = 80
    self.speed = 300
    self.xVel = 0
    self.yVel = 0

    self.pm = 3
    self.maxspeed = 200 * self.pm
    self.acceleration = 4000 * self.pm
    self.friction = 3500 * self.pm
    self.gravity = 2300
    self.jumpamount = -800
    self.grounded = false

    self.physics = {}
    self.physics.body = world:newRectangleCollider(self.x,self.y,self.width,self.height)
    self.physics.body:setCollisionClass('Player')
    self.physics.body:setFixedRotation(true)
    self.physics.fixtures = self.physics.body:getFixtures()

    self.load_conplete = true
end


function Player:update(dt)
    if self.load_conplete then
        self:syncPhysics()
        self:jumpContact()
        self:endContact()
        self:move(dt)
        self:applyGravity(dt)
    end
end


function Player:draw()
    if self.load_conplete then
        love.graphics.rectangle("fill",self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    end
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

function Player:jumpContact()
    if self.physics.body:enter('Ground') or self.physics.body:enter('Platform') then
        if self.grounded == true then return end
        local collision_data = self.physics.body:getEnterCollisionData('Ground')
        local nx ,ny = collision_data.contact:getNormal()
        if ny < 0 then
            self:onGround(collision_data.collider)
        elseif ny == 1 then
            self:nonGround(collision_data.collider)
        end
    end
end

function Player:endContact()
    if self.physics.body:exit('Ground') or self.physics.body:exit('Platform') then
        local collision_data = self.physics.body:getExitCollisionData('Ground')
        if self.currentGroundCollision == collision_data.collider then
            self.grounded = false
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
    if self.load_conplete then
        if (key == "w" or key == "up" or key == "space") and self.grounded == true then
            self.yVel = 0
            self.yVel = self.jumpamount
            self.grounded = false
        end
    end
end

function Player:syncPhysics()
    self.physics.body:setLinearVelocity(self.xVel,self.yVel)
    self.x,self.y = self.physics.body:getPosition()
end