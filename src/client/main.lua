local wf = require('lib.windfield')
local flux = require("lib.flux")

require("gui.main")
require("lib.map")
require("player")

function love.load()
	world = wf.newWorld(0, 0)
    world:addCollisionClass('Player')
    world:addCollisionClass('Ground')
    world:addCollisionClass('Platform')
    world:setCallbacks(beginContact,endContact)
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
end

function love.draw()
    if Player.load_conplete then
        map:draw()
        world:draw()
    end
	love.graphics.push()
    gui:draw()
	Player:draw()
	love.graphics.pop()
end

function love.keypressed(key, scancode, isrepeat)
    Player:jump(key)
end

function love.mousepressed(x,y,key)
    love.thread.getChannel('mouseKey'):push(key)
    print(key)
end

function beginContact(a, b , collision)
    Player:beginContact(a, b , collision)
end

function endContact(a, b , collision)
    Player:endContact(a, b , collision)
end