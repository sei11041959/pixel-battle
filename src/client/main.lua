local wf = require('lib.windfield')

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
	Player:load()
end

function love.update(dt)
    gui:updata(dt)
	world:update(dt)
	Player:update(dt)
end

function love.draw()
    love.graphics.draw(love.graphics.newImage("assets/img/background.png"))
    map:draw()
    gui:draw()
    world:draw()
	--love.graphics.push()
	Player:draw()
	--love.graphics.pop()
end

function love.keypressed(key, scancode, isrepeat)
    Player:jump(key)
end

function beginContact(a, b , collision)
    Player:beginContact(a, b , collision)
end

function endContact(a, b , collision)
    Player:endContact(a, b , collision)
end