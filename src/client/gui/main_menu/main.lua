local helium = require("lib.helium")

require("gui.button_creater")
require("player")

main_menu = {}

local ww = love.graphics.getWidth()
local wh = love.graphics.getHeight()

local button_width = ww * (1/3)
local button_height = 80

local bx = (ww * 0.5) - (button_width * 0.5)
local by = (wh * 0.5) - (button_height * 0.5)

local font = love.graphics.newFont(32)

local menu = helium.scene.new(true)
menu:activate()

function start_func()
    Player:load()
end

function main_menu:load()
    startButton = buttonbase({bx = 0,by = 0,text = "",func = start_func},button_width,button_height)
    startButton:draw(bx,by,w,h)
end

function main_menu:update(dt)
    menu:update()
end

function main_menu:draw()
    menu:draw()
end