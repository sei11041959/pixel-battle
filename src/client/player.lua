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
    self.rotation = "right"

    self.pm = 3
    self.maxspeed = 200 * self.pm
    self.acceleration = 4000 * self.pm
    self.friction = 3500 * self.pm
    self.gravity = 2300
    self.jumpamount = -800
    self.grounded = false

    self.body = world:newRectangleCollider(self.x,self.y,self.width,self.height)
    self.body:setCollisionClass('Player')
    self.body:setFixedRotation(true)
    self.fixtures = self.body:getFixtures()

    self.body:setPreSolve(function(a, b, contact)
        if a.collision_class  == "Player" and b.collision_class == "AttackRange" then
            contact:setEnabled(false)
        end
    end)

    self.load_conplete = true
end


function Player:update(dt)
    if self.load_conplete then
        self:syncPhysics()
        self:JumpContact()
        self:JumpENDContact()
        self:move(dt)
        self:AttackCollider_update(dt)
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
        self.rotation = "right"
        if self.xVel < self.maxspeed then
            if self.xVel + self.acceleration * dt < self.maxspeed then
                    self.xVel = self.xVel + self.acceleration * dt
            else
                self.xVel = self.maxspeed
            end
        end
    elseif love.keyboard.isDown("a","left") then
        self.rotation = "left"
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
    self.body:setLinearVelocity(self.xVel,self.yVel)
    self.x,self.y = self.body:getPosition()
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function Player:JumpContact()
    local collision_data;
    if self.body:enter('Dummy') then
        if self.grounded == true then return end
        collision_data = self.body:getEnterCollisionData('Dummy')
        local nx ,ny = collision_data.contact:getNormal()
        print(nx,ny)
        if ny < 0 then
            self:nonGround(collision_data.collider)
        elseif ny > 0 then
            self:onGround(collision_data.collider)
        end
        return
    end
    if self.body:enter('Ground') then
        if self.grounded == true then return end
        collision_data = self.body:getEnterCollisionData('Ground')
    elseif self.body:enter('Platform') then
        if self.grounded == true then return end
        collision_data = self.body:getEnterCollisionData('Platform')
    end
    if collision_data then
        local nx ,ny = collision_data.contact:getNormal()
        print(nx,ny)
        if ny < 0 then
            self:onGround(collision_data.collider)
        elseif ny == 1 then
            self:nonGround(collision_data.collider)
        end
    end
end

function Player:JumpENDContact()
    local collision_data;
    if self.body:exit('Ground') then
        collision_data = self.body:getExitCollisionData('Ground')
    elseif self.body:exit('Platform') then
        collision_data = self.body:getExitCollisionData('Platform')
    elseif self.body:exit('Dummy') then
        collision_data = self.body:getExitCollisionData('Dummy')
    end
    if collision_data then
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
        if (key == "w" or key == "up") and self.grounded == true then
            self.yVel = 0
            self.yVel = self.jumpamount
            self.grounded = false
        end
    end
end

function beginContact()
    if self.load_conplete then
    end
end

function endContact()
    if self.load_conplete then
    end
end

function Player:AttackCollider(key)
    if self.load_conplete then
        if key == "space" and not self.attack then
            if self.rotation == "right" then
                self.attack = world:newRectangleCollider(self.x+11,self.y-15,30,30)
                self.attack:setCollisionClass('AttackRange')
            elseif self.rotation == "left" then
                self.attack = world:newRectangleCollider(self.x-31,self.y-15,30,30)
                self.attack:setCollisionClass('AttackRange')
            end
        end
    end
end

function Player:AttackCollider_update(dt)
    if self.attack then
        if self.attack:enter('Dummy') then
            local collision_data = self.attack:getEnterCollisionData('Dummy')
            local collider = collision_data.collider
            local dummy = collider:getObject()
            if self.rotation == "right" then
                dummy.xVel = 2000
                dummy.yVel = -400
            elseif self.rotation == "left" then
                dummy.xVel = -2000
                dummy.yVel = -400
            end
        end
        self.attack:destroy()
        self.attack = nil
    end
end