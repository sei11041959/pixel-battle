local helium = require('lib.helium')
local useState = require('lib.helium.hooks.state')
local input = require('lib.helium.core.input')
local useButton = require('lib.helium.shell.button')
local flux = require("lib.flux")


button = {}

return helium(function (param,view)
    local font = useState{size = 40}

    local clickSFX = love.audio.newSource("assets/audio/click.wav", "static")
    local buttonfont = love.graphics.newFont('assets/font/UbuntuMono-R.ttf', font.size)

    local aqua = {0,0,90}
    local white = {255,255,255}


    local button_color = param.color

    local bx,by = param.bx,param.by
    local w,h = view.w,view.h

    local text = param.text

    local textS = useState{
        tw = buttonfont:getWidth(text),
        th = buttonfont:getHeight(text)
    }
    local textP = useState{
        x = (w * 0.5) - textS.tw * 0.5,
        y = by + textS.th * 0.5
    }

    local HPW = useState{w = 0} --HOVER PROGRESS WITDH
    local HPC = useState{param.HPC[1],param.HPC[2],param.HPC[3],0}-- HOVER PROGRESS COLOR

    local bState = useButton(
        function ()
            if param.func and not Player.load_conplete then
                param.func()
                love.audio.play(clickSFX)
            end
        end,
        nil,
        function ()
            flux.to(HPC,0.3,{param.HPC[1],param.HPC[2],param.HPC[3],0.4})
        end,
        function ()
            button_color = white
            flux.to(HPC,0.1,{param.HPC[1],param.HPC[2],param.HPC[3],0})
        end
    )
    return function ()
        love.graphics.setColor(button_color)
        love.graphics.rectangle("fill",bx,by,w,h)
        love.graphics.setColor(HPC[1],HPC[2],HPC[3],HPC[4])
        love.graphics.rectangle("fill",bx,by,w,h)
        love.graphics.setColor({0,0,0})
		love.graphics.print(text,buttonfont,textP.x,textP.y)
    end
end)