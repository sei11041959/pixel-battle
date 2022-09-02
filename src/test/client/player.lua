local wf = require('lib.windfield')

Player = {}

function Player:load(data)
    self.x = data.x
    self.y = data.y
    self.width = data.width
    self.height = data.height
    self.speed = data.speed
    self.xVel = data.xVel
    self.yVel = data.yVel
    self.rotation = data.rotation
    self.down = data.down
    self.connection_number = data.connection

    self.load_conplete = true
end


function Player:update(dt,client)
    self:move()
    self:data_update(client)
end

function Player:data_receive(data,client)
    if data.connection == self.connection_number then
        for key, value in pairs(data) do
            Player[key] = value
        end
    end
end

function Player:draw()
    if self.load_conplete then
        love.graphics.rectangle("fill",self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    end
end

function Player:move()
    if love.keyboard.isDown("d","right") then
        self.rotation = "right"
        self.down = true
    elseif love.keyboard.isDown("a","left") then
        self.rotation = "left"
        self.down = true
    else
        self.down = false
    end
end

function Player:data_update(client)
    client:send('update',{
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height,
        speed = self.speed,
        xVel = self.xVel,
        yVel = self.yVel,
        rotation = self.rotation,
        down = self.down,
        connection = self.connection
    })
end