local sock = require("lib.sock")
local wf = require("lib.windfield")
local bitser = require("lib.bitser")

require("lib.map")
require("world")
require("player")

connection = 0

function love.load()
    server = sock.newServer("*", 8080)
    server:setSerialization(bitser.dumps, bitser.loads)

    world_2d_box:load()
    map:load()

    server:on("connect", function(data,client)
        print("Client connected to the server")
        connection = connection + 1
        map:menu_map_data(data,client)
        Player:newPlayer(client,connection)
    end)

    server:on("update", function(data,client)
        Player:data_receive(data)
    end)
end


function love.update(dt)
    datatime = dt
    server:update()
    world_2d_box:update(dt)
    map:update(dt)
    Player:update(dt,server)
end

function love.draw()
    map:draw()
    Player:draw()
    world_2d_box:draw()
end