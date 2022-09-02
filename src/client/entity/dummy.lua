local wf = require('lib.windfield')

Dummy = {}

function Dummy:load()
    self.x = love.graphics.getWidth() / 2 + 100
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
    self.physics.body:setCollisionClass('Dummy')
    self.physics.body:setFixedRotation(true)
    self.physics.body:setObject(self)
    self.physics.fixtures = self.physics.body:getFixtures()

    self.load_conplete = true
end


function Dummy:update(dt)
    if self.load_conplete then
        self:syncPhysics()
        self:jumpContact()
        self:endContact()
        self:applyFriction(dt)
        self:applyGravity(dt)
    end
end


function Dummy:draw()
    if self.load_conplete then
        -- love.graphics.rectangle("fill",self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    end
end


function Dummy:applyFriction(dt)
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

function Dummy:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function Dummy:jumpContact()
    local collision_data;
    if self.physics.body:enter('Ground') then
        if self.grounded == true then return end
        collision_data = self.physics.body:getEnterCollisionData('Ground')
    elseif self.physics.body:enter('Platform') then
        if self.grounded == true then return end
        collision_data = self.physics.body:getEnterCollisionData('Platform')
    end
    if collision_data then
        local nx ,ny = collision_data.contact:getNormal()
        if ny < 0 then
            self:onGround(collision_data.collider)
        elseif ny == 1 then
            self:nonGround(collision_data.collider)
        end
    end
end

function Dummy:endContact()
    local collision_data;
    if self.physics.body:exit('Ground') then
        collision_data = self.physics.body:getExitCollisionData('Ground')
    elseif self.physics.body:exit('Platform') then
        collision_data = self.physics.body:getExitCollisionData('Platform')
    end
    if collision_data then
        if self.currentGroundCollision == collision_data.collider then
            self.grounded = false
        end
    end
end

function Dummy:onGround(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
end

function Dummy:nonGround(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = false
end

function Dummy:syncPhysics()
    self.physics.body:setLinearVelocity(self.xVel,self.yVel)
    self.x,self.y = self.physics.body:getPosition()
end