local helium = require('lib.helium')
local useState = require('lib.helium.hooks.state')
local input = require('lib.helium.core.input')
local useButton = require('lib.helium.shell.button')

button = {}

local clickSFX = love.audio.newSource("assets/audio/click.wav", "static")
local ww = love.graphics.getWidth()
local wh = love.graphics.getHeight()
local font = love.graphics.newFont(32)

buttonbase = helium(function (param,view)
    local buttonState = useButton()
    love.graphics.setColor(255,255,255)
    local bx,by = param.bx,param.by
    local w,h = view.w,view.h
    return function ()
        if buttonState.over then
            love.graphics.setColor(0,0,255)
        else
            love.graphics.setColor(255,255,255)
        end
        if buttonState.down then
            love.graphics.setColor(0,0,0)
            love.audio.play(clickSFX)
            if param.func and not Player.load_conplete then
                param.func()
            end
        end
        --love.graphics.print(param.text,font)
        love.graphics.rectangle("fill",bx,by,w,h)
    end
end)