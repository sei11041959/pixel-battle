local helium = require("lib.helium")
local button_creater = require("gui.button_creater")

require("player")
require("entity.dummy")


return helium(function(param, view)
    local ww = view.w
    local wh = view.h

    local bw = ww * (1/3)
    local bh = 80

    local bx = (ww * 0.5) - (bw * 0.5)
    local by = (wh * 0.5) - (bh * 0.5)

    local margin = 30

    local start = button_creater(
        {bx = 0,
        by = 0,
        text = "start",
        color = {255,255,255},
        animation = {0,0,0},
        func = function ()
            Player:load()
            Dummy:load()
        end,
        HPC = {0,0,60}},
        bw,
        bh
    )
    local quit = button_creater(
        {bx = 0 ,
        by = 0 ,
        text = "QUIT",
        func = function ()
            os.exit()
        end,
        color = {255,255,255},
        animation = {180,180,180},
        HPC = {225,0,0}},
        bw,
        bh
    )


	return function()
        start:draw(bx,by,bw,bh)
        quit:draw(bx,by + (bh + margin),bw,bh)
	end
end)