local sti = require("lib.sti")

map = {}
collider = {}

function map:load()
    MenuMap = sti("assets/maps/menu.lua", {"box2d"})
    if MenuMap.layers["NormalCollied"] then
        MenuMap.layers.NormalCollied.visible = false
        for i, obj in ipairs(MenuMap.layers["NormalCollied"].objects) do
            local collide = world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
            collide:setType("static")
            table.insert(collider,collide)
        end
    end
end


function map:update(dt)
    
end


function map:draw()
    MenuMap:draw(0,0)
end