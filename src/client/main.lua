local wf = require('lib.windfield')
local flux = require("lib.flux")

require("gui.main")
require("lib.map")
require("player")
require("entity.dummy")

function love.load()
	world = wf.newWorld(0, 0)
    world:addCollisionClass('Player')
    world:addCollisionClass('AttackRange')
    world:addCollisionClass('Dummy')
    world:addCollisionClass('Ground')
    world:addCollisionClass('Platform')
    gui:load()
    map:load()
	--Player:load()
end

function love.update(dt)
    flux.update(dt)
    if Player.load_conplete then
        world:update(dt)
        map:update(dt)
    end
    gui:update(dt)
	Player:update(dt)
    Dummy:update(dt)
end

function love.draw()
    if Player.load_conplete then
        map:draw()
        world:draw()
    end
    love.graphics.push()
    gui:draw()
	Player:draw()
    love.graphics.print(love.timer.getFPS(),0,0)
	love.graphics.pop()
end

function love.keypressed(key, scancode, isrepeat)
    Player:jump(key)
    Player:AttackCollider(key)
end

function love.mousepressed(x,y,key)
end