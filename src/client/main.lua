local sti = require("lib.sti")
local wf = require('lib.windfield')

require("player")

local collider = {}

function love.load()
	Map = sti("assets/maps/menu.lua", {"box2d"})
	world = wf.newWorld(0, 0)
    world:setCallbacks(beginContact,endContact)
    if Map.layers["collide"] then
        Map.layers.collide.visible = false
        for i, obj in ipairs(Map.layers["collide"].objects) do
            local collide = world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
            collide:setType("static")
            table.insert(collider,collide)
        end
    end
	Player:load()
end

function love.update(dt)
	world:update(dt)
	Player:update(dt)
end

function love.draw()
	Map:draw(0, 0)
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