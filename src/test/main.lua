local wf = require('windfield')


local clickSFX = love.audio.newSource("assets/audio/click.wav", "static")

function love.load()
    world = wf.newWorld(0, 0, true)
    world:setGravity(0,512)

    world:addCollisionClass('Solid')

    box = world:newRectangleCollider(400 - 100, 0, 50, 50)
    box:setRestitution(1)

    ground = world:newRectangleCollider(0, 550, 800, 50)
    wall_top = world:newRectangleCollider(0, 0, 800, 50)
    wall_left = world:newRectangleCollider(0, 0, 50, 600)
    wall_right = world:newRectangleCollider(750, 0, 50, 600)

    ground:setType('static')
    wall_top:setType('static')
    wall_left:setType('static')
    wall_right:setType('static')

    ground:setCollisionClass('Solid')
    wall_top:setCollisionClass('Solid')
    wall_left:setCollisionClass('Solid')
    wall_right:setCollisionClass('Solid')
end

function love.update(dt)
    world:update(dt)
    if box:enter('Solid') then
        local v = love.math.random(1,2)
        if v == 1 then
            n = love.math.random(500,1000)
        else
            n = love.math.random(-500,-1000)
        end
        box:applyLinearImpulse(n,-500)
        if v == 1 then
            box:applyAngularImpulse(3000)
        else
            box:applyAngularImpulse(-3000)
        end
        love.audio.play(clickSFX)
    end
end


function love.draw()
    world:draw() -- The world can be drawn for debugging purposes
end