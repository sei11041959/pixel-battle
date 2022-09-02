local sti = require("lib.sti")
local menu = require("assets/maps/menu")

map = {}
collider = {}
test = {}

local background = love.graphics.newImage("assets/img/background.png")

function map:load()
    MenuMap = sti("assets/maps/menu.lua", {"box2d"})
    if MenuMap.layers["GroundCollision"] then
        MenuMap.layers.GroundCollision.visible = false
        for i, obj in ipairs(MenuMap.layers["GroundCollision"].objects) do
            vertices = {}
            for _, vertice in pairs(obj.polygon) do
                table.insert(vertices,vertice.x)
                table.insert(vertices,vertice.y)
                table.insert(test,{x = vertice.x,y = vertice.y})
            end
            local collide = world:newChainCollider(true,vertices)
            collide:setType("static")
            collide:setCollisionClass('Ground')
            table.insert(collider,collide)--]]
        end
    end
    if MenuMap.layers["PlatformCollision"] then
        MenuMap.layers.PlatformCollision.visible = false
        for i, obj in ipairs(MenuMap.layers["PlatformCollision"].objects) do
            local vertices = {}
            for _, vertice in pairs(obj.polygon) do
                table.insert(vertices,vertice.x)
                table.insert(vertices,vertice.y)
                table.insert(test,{x = vertice.x,y = vertice.y})
            end
            local collide = world:newChainCollider(true,vertices)
            collide:setType("static")
            collide:setCollisionClass('Platform')
            table.insert(collider,collide)
        end
    end
end


function map:update(dt)
    MenuMap:update(dt)
end


function map:draw()
    love.graphics.draw(background)
    MenuMap:draw()
    for i, v in ipairs(test) do
        love.graphics.rectangle("fill",v.x-2.5,v.y-2.5,5,5)
    end
end

function map:menu_map_data(data,client)
    client:send("menu_map_data",menu)
end