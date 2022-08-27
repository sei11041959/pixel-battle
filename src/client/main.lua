local sti = require("lib.sti")

require("menu.main")


function love.load()
    map = sti("assets/maps/test.lua")
    --menu:load()
end


function love.update(dt)
    --menu:updata(dt)
end


function love.draw()
    map:draw()
    --menu:draw()
end