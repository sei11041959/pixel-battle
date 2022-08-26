local sock = require("lib.sock")

-- client.lua
function love.load()
    client = sock.newClient("127.0.0.1", 22122)

    client:on("connect", function(data)
        print("Client connected to the server.")
    end)

    client:on("disconnect", function(data)
        print("Client disconnected from the server.")
    end)

    client:connect()
end

function love.update(dt)
    client:update()
end


function love.draw()
end