-- Copyright 2026 Natalie Baker -- AGPLv3.0 --

--- @class LoveGame
--- @field load fun()
--- @field updateFixed fun(dt: number)
--- @field update fun(dt: number)
--- @field framePrepare fun(dt: number)
--- @field frameDraw fun()
--- @field timerFixed TimerFixed
lovely = {
    load         = function () end,
    updateFixed  = function (dt) end,
    update       = function (dt) end,
    framePrepare = function (dt) end,
    frameDraw    = function () end,
    timerFixed   = require("lib.timerfixed").new()
}
require("src.game")

function love.load()
    lovely.load()
end

function love.update(dt)
    lovely.timerFixed:process(dt, function(fdt) lovely.updateFixed(fdt) end)
    lovely.update(dt)
    lovely.framePrepare(dt)
end

function love.draw()
    lovely.frameDraw()
end
