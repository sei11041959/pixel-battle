local sock = require("lib.sock")

data_center = {}

local client;
local isConnected;

function data_center:load()
end

function data_center:updata(dt)
    if isConnected then
        client:updata()
    end
end

function data_center:connect()
    client = sock.newClient("127.0.0.1", 22122)

    client:on("connect", function(data)
        print("Client connected to the server.")
    end)

    client:on("disconnect", function(data)
        print("Client disconnected from the server.")
    end)

    client:connect()
end