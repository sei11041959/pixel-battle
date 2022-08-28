local wf = require('lib.windfield')

require("menu.map")
require("player")

function love.load()
	world = wf.newWorld(0, 0)
    world:addCollisionClass('Player')
    world:setCallbacks(beginContact,endContact)
    map:load()
	Player:load()
end

function love.update(dt)
	world:update(dt)
	Player:update(dt)
end

function love.draw()
    map:draw()
    world:draw()
	love.graphics.push()
	Player:draw()
	love.graphics.pop()
end

function love.keypressed(key)
    Player:jump(key)
end

function beginContact(a, b , collision)
    Player:beginContact(a, b , collision)
end

function endContact(a, b , collision)
    Player:endContact(a, b , collision)
end