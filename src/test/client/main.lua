local sock = require("lib.sock")
local wf = require("lib.windfield")
local sti = require("lib.sti")

require("lib.map")
require("player")
require("world")

function love.load()
    client = sock.newClient("localhost", 8080)

    client:on("connect", function(data)
        print("Client connected to the server")
    end)

    client:on('menu_map_data',function (data)
        data.tilesets[1].image = "assets/tileset/ground.png"
        menu = sti(data, {"box2d"})
        map:load(menu)
    end)

    client:on("spawn", function(data)
        Player:load(data)
    end)

    client:on("update", function(data,client)
        Player:data_receive(data,client)
    end)

    client:on("msg", function(msg)
        print(msg)
    end)

    world_2d_box:load()
    client:connect()
end

function love.update(dt)
    client:update()
    world_2d_box:update(dt)
    if menu then
        map:update(dt)
        Player:update(dt,client)
    end
end

function love.draw()
    if menu then
        map:draw()
    end
    Player:draw()
    world_2d_box:draw()
end