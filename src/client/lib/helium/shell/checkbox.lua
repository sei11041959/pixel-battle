local path = string.sub(..., 1, string.len(...) - string.len(".shell.button"))
local state = require(path.. ".hooks.state")
local input = require(path.. ".core.input")

---@class checkboxState
---@param down boolean @indicates whether this element is currently held down
---@param toggled boolean @current state of the checkbox
---@param over boolean @indicates whether the mouse is over this field

---A wrapper for state and subscriptions for a checkbox
---@param onClick function|nil
---@param onRelease function|nil
---@param onEnter function|nil
---@param onExit function|nil
---@param startOn boolean|nil
---@param x number|nil
---@param y number|nil
---@param w number|nil
---@param h number|nil
---@return checkboxState
return function(onClick, onRelease, onEnter, onExit, startOn, x, y, w, h)
	local checkbox = state {
		down = false,
		toggled = not not startOn,
		over = false,
	}
	input('clicked', function(x, y, w, h)
		if onClick then
			onClick(x, y, w, h)
		end

		checkbox.down = true
		
		return function(x, y, w, h)
			if onRelease then
				onRelease(x, y, w, h)
			end
			checkbox.toggled = not checkbox.toggled
			checkbox.down = false
		end
	end)

	input('hover', function(x, y, w, h) 
		if onEnter then
			onEnter(x, y, w, h)
		end

		checkbox.over = true

		return function(x, y, w, h)
			if onExit then
				onExit(x, y, w, h)
			end

			checkbox.over = false
		end
	end)

	return checkbox
end