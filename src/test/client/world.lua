local wf = require('lib.windfield')

world_2d_box = {}

function world_2d_box:load()
    world = wf.newWorld(0, 0, true)

    world:addCollisionClass('Player')
    world:addCollisionClass('Ground')
    world:addCollisionClass('Platform')
end

function world_2d_box:update(dt)
    world:update(dt)
end

function world_2d_box:draw()
    world:draw()
end