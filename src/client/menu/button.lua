require("lib.log")

Button = {}


local buttons = {}


function newButton(text,func)
    table.insert(buttons,{
        text = text,
        func = func,
        now = false,
        last = false
    })
end


function Button:load()
    newButton("start",function ()
        buttons = nil
    end)
    newButton("quit",function()
        print("quit")
        os.exit()
    end)
end

function Button:draw()
    if buttons ~= nil then
        local ww = love.graphics.getWidth()
        local wh = love.graphics.getHeight()

        local button_width = ww * (1/3)
        local button_height = 80
        local margin = 20
        local total_height = (button_height + margin) * #buttons
        local cursor_y = 0
        local font = love.graphics.newFont(32)

        for i,button in ipairs(buttons) do
            button.last = button.now

            local bx = (ww * 0.5) - (button_width * 0.5)
            local by = (wh * 0.5) - (button_height * 0.5) - (total_height * 0.5) + cursor_y

            local textW = font:getWidth(button.text)
            local textH = font:getHeight(button.text)
            local color = {255,255,255,1.0}

            local mx,my = love.mouse.getPosition()
            local hover = mx > bx and mx < bx +button_width and my > by and my < by + button_height

            if hover then
                color = {0.4,0.4,0.5,1.0}
            end

            button.now = love.mouse.isDown(1)
            if hover and button.now and not button.last then
                local clieckfx = love.audio.newSource("assets/click.wav","static")
                love.audio.play(clieckfx)
                button.func()
            end


            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill",bx,by,button_width,button_height)
            love.graphics.setColor(0,0,0,1)
            love.graphics.print(button.text,font,(ww * 0.5) - textW * 0.5,by + textH * 0.5)

            cursor_y = cursor_y + (button_height + margin)
        end
    end
end