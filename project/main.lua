-- Copyright 2026 Natalie Baker -- AGPLv3.0 --

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
end

function love.draw()
    love.graphics.print("Hello World", 100, 100)
end
