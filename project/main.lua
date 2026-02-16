-- Copyright 2026 Natalie Baker -- AGPLv3.0 --

local v2d = require("lib.shrimpvec")

local v = v2d(400, 300)

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)

end

function love.draw()
    love.graphics.print("Hello World", (v/10).x, (v*1.1).y)
end
