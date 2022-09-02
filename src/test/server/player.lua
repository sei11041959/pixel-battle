local wf = require('lib.windfield')

Player = {}
Players = {}
Players_Collision = {}

function Player:newPlayer(client,connection)
    local player = {
        x = love.graphics.getWidth() / 2,
        y = 0,
        width = 20,
        height = 80,
        speed = 300,
        xVel = 0,
        yVel = 0,
        rotation = "right",
        down = false,
        connection = connection
    }
    client:send("spawn",player)
    pm = 3
    player = {
        x = love.graphics.getWidth() / 2,
        y = 0,
        width = 20,
        height = 80,
        speed = 300,
        xVel = 0,
        yVel = 0,
        rotation = "right",
        connection = connection,
        maxspeed = 200 * pm,
        acceleration = 4000 * pm,
        friction = 3500 * pm,
        gravity = 2300,
        jumpamount = -800,
        grounded = false
    }
    local collider = world:newRectangleCollider(player.x,player.y,player.width,player.height)
    collision = {
        connection = connection,
        collider = collider,
        collider:setCollisionClass('Player'),
        collider:setFixedRotation(true),
        fixtures = collider:getFixtures(),
    }
    table.insert(Players,player)
    table.insert(Players_Collision,collision)
end

function Player:load()
end


function Player:update(dt,server)
    self:syncPhysics()
    self:move(dt)
    self:sendToAllData(server)
end


function Player:draw()
    for i, player in ipairs(Players) do
        love.graphics.rectangle("fill",player.x - player.width / 2, player.y - player.height / 2, player.width, player.height)
    end
end


function Player:syncPhysics()
    for i, data in ipairs(Players) do
        for n, v in ipairs(Players_Collision) do
            if v.connection == data.connection then
                v.collider:setLinearVelocity(data.xVel,data.yVel)
                data.x,data.y = v.collider:getPosition()
            end
        end
    end
end

function Player:move(dt)
    for i, data in ipairs(Players) do
        if data.down and data.rotation == "right" then
            if data.xVel < data.maxspeed then
                if data.xVel + data.acceleration * dt < data.maxspeed then
                        data.xVel = data.xVel + data.acceleration * dt
                else
                    data.xVel = data.maxspeed
                end
            end
            -- print(data.xVel)
        elseif data.down and data.rotation == "left" then
            if data.xVel >  -data.maxspeed then
                if data.xVel - data.acceleration * dt > -data.maxspeed then
                    data.xVel = data.xVel - data.acceleration * dt
                else
                    data.xVel = -data.maxspeed
                end
            end
            -- print(data.xVel)
        else
            Player:applyFriction(dt,data)
        end
    end
end

function Player:applyFriction(dt,data)
    if data.xVel > 0 then
        if data.xVel - data.friction * dt > 0 then
           data.xVel = data.xVel - data.friction * dt
        else
           data.xVel = 0
        end
     elseif data.xVel < 0 then
        if data.xVel + data.friction * dt < 0 then
           data.xVel = data.xVel + data.friction * dt
        else
           data.xVel = 0
        end
     end
end


function Player:data_receive(data)
    for key, value in pairs(data) do
        -- print(data.connection)
        Players[data.connection][key] = value
    end
end

function Player:sendToAllData(server)
    for i, data in ipairs(Players) do
        server:sendToAll("update",{
            x = data.x,
            y = data.y,
            width = data.width,
            height = data.height,
            speed = data.speed,
            xVel = data.xVel,
            yVel = data.yVel,
            rotation = data.rotation,
            down = data.down,
            connection = data.connection
        })
    end
end