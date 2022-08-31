local helium = require("lib.helium")
local button_creater = require("gui.button_creater")

require("player")

main_menu = {}

local menu_scene = helium.scene.new(true)

local ww = love.graphics.getWidth()
local wh = love.graphics.getHeight()

function main_menu:load()
    local menu = require("gui.main_menu.menu")({x = 0, y = 0},ww,wh)
    menu_scene:activate()
    menu:draw(0,0,ww,wh)
end

function main_menu:update(dt)
    if Player.load_conplete then
        menu_scene:deactivate()
        menu_scene:reload()
        menu_scene:unload()
    else
        menu_scene:update()
    end
end

function main_menu:draw()
    if not Player.load_conplete then
        menu_scene:draw()
    end
end