-- Copyright 2026 Natalie Baker -- AGPLv3.0 --

local log = require("lib.log")

--- Setup the game
function lovely.load()
    log.trace("Called lovegame.update")
end

--- Update the game (fixed-dt)
function lovely.updateFixed(dt)
    log.trace("Called lovegame.updateFixed")
end

--- Update the game (real-dt)
function lovely.update(dt)
    log.trace("Called lovegame.update")
end

--- Prepare frame for rendering (real-dt)
function lovely.framePrepare(dt)
    log.trace("Called lovegame.framePrepare")
end

--- Issue draw commands
function lovely.frameDraw()
    log.trace("Called lovegame.frameDraw")
end
