-- Copyright 2026 Natalie Baker -- AGPLv3.0 --

--- @class LoveGame
--- @field load fun(arg: table, unfilteredArg: table)
--- @field updateFixed fun(dt: number)
--- @field update fun(dt: number)
--- @field framePrepare fun(dt: number)
--- @field frameDraw fun()
--- @field timerFixed TimerFixed
lovely = {
    load         = function (arg, unfilteredArg) end,
    updateFixed  = function (dt) end,
    update       = function (dt) end,
    framePrepare = function (dt) end,
    frameDraw    = function () end,
    timerFixed   = require("lib.timerfixed").new()
}
require("src.game")

love.load = lovely.load
love.draw = lovely.frameDraw

function love.update(dt)
    lovely.timerFixed:process(dt, function(fdt) lovely.updateFixed(fdt) end)
    lovely.update(dt)
    lovely.framePrepare(dt)
end

-- Custom love.run loop from 12.0 version
-- - Modified to not wait 0.001
function love.run()
    ---@diagnostic disable-next-line: undefined-field
	if love.load then love.load(love.parsedGameArguments, love.rawGameArguments) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f,g,h in love.event.poll() do
				if name == "quit" then
                    ---@diagnostic disable-next-line: undefined-field
					if c or not love.quit or not love.quit() then
						return a or 0, b
					end
				end

                ---@diagnostic disable-next-line: undefined-field
				love.handlers[name](a,b,c,d,e,f,g,h)
			end
		end

		-- Update dt, as we'll be passing it to update
		local dt = love.timer and love.timer.step() or 0

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		-- if love.timer then love.timer.sleep(0.001) end -- Just no
	end
end