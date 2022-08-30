require("gui.main_menu.main")

gui = {}


function gui:load()
    main_menu:load()
end

function gui:update(dt)
    main_menu:update(dt)
end


function gui:draw()
    main_menu:draw()
end