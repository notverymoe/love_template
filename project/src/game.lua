
local log = require("lib.log")

--- Setup the game
function love.load()
    log.trace("Called love.load")
end

--- Update the game (real-dt)
function love.update(dt)
    log.trace("Called love.update")
end

--- Issue draw commands
function love.draw()
    log.trace("Called love.draw")
end
