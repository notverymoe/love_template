
---------------
-- Shrimpvec --
---------------
-- Shrimpvec is a modified version of Brinevector
--
-- -- Changelog --
--
-- 2026-02-16
-- - It makes all operators component-wise and compatible with number
-- - Removes error checking
-- - Adds version of normalize that doesn't check for a zero-length vector
-- - Add __DESCRIPTION, __VERSION and __LICENSE fields.
--
-----------------
-- Brinevector --
-----------------
-- Brinevector is a luajit ffi-accelerated vector library
--
-- -- Changelog --
--
-- 2202-08-22
-- hadamard product is now done with a default * operator
-- dot product is now done with Vector.dot
-- better error messages (thanks to Andrew Minnich)
--
-- 2018-09-25
-- added Vector.ceil and v.ceil
-- added Vector.clamp
-- changed float to double as per Mike Pall's advice
-- added Vector.floor
-- added fallback to table if luajit ffi is not detected (used for unit tests)
--

local Vector = {
--    __HOMEPAGE = 'https://github.com/novemberisms/brinevector/tree/master',
    __DESCRIPTION = 'A luajit ffi-accelerated vector library, based on brinevector',
    __VERSION = '2026.02.19',
    __LICENSE = [[
        MIT License

        Copyright 2022 Brian Sarfati

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    ]]
}

-- Prevent adding properties to v2d values
function Vector.__newindex(t, k, v)
    if t == Vector then
        rawset(t, k, v)
    else
        error("Cannot assign a new property '" .. k .. "' to a Vector", 2)
    end
end

-- Select FFI or Tables
local ffi
local VECTORTYPE = "cdata"

if jit and jit.status() then
    ffi = require "ffi"
    ffi.cdef [[
        typedef struct {
            double x;
            double y;
        } shrimpvec;
    ]]
else
    VECTORTYPE = "table"
end

-- Internal Util -- 

local function unpackOrSpread(v)
    if type(v) == "number" then
        return v, v
    else
        return v.x, v.y
    end
end

local function clamp(x, min, max)
    return math.min(math.max(min, x), max)
end

-- Module New --

if ffi then   
    setmetatable(Vector, {
        __call = function(t, x, y)
            y = y or x or 0
            x = x or 0
            return ffi.new("shrimpvec", x, y)
        end
    })
    ffi.metatype("shrimpvec", Vector)
else
    setmetatable(Vector, {
        __call = function(t, x, y)
            y = y or x or 0
            x = x or 0
            return setmetatable({ x = x, y = y }, Vector)
        end
    })
end

-- Utility --

function Vector.copy(v)
    return Vector(v.x, v.y)
end

function Vector.spread(v)
    return v.x, v.y
end

-- Calculations, Unary --

function Vector.length(v)
    return math.sqrt(v.x*v.x + v.y*v.y)
end

function Vector.lengthSquared(v)
    return v.x*v.x + v.y*v.y
end

function Vector.angle(v)
    return math.atan2(v.y, v.x)
end

-- Calculations, Binary --

function Vector.dot(v1, v2)
    return v1.x * v2.x + v1.y * v2.y
end

-- Transformations, Unary --

function Vector.setLength(v, mag)
    return v:normalizeOrZero() * mag
end

function Vector.normalizeOrZero(v)
    local length = v:length()
    if length == 0 then
        return Vector(0, 0)
    else
        return Vector(
            v.x / length,
            v.y / length
        )
    end
end

function Vector.normalize(v)
    local lengthInv = 1/v:length()
    return Vector(
        v.x * lengthInv,
        v.y * lengthInv
    )
end

function Vector.inverse(v)
    return Vector(1 / v.x, 1 / v.y)
end

function Vector.floor(v)
    return Vector(math.floor(v.x), math.floor(v.y))
end

function Vector.ceil(v)
    return Vector(math.ceil(v.x), math.ceil(v.y))
end

-- Transformations --

function Vector.clamp(v, min, max)
    return Vector(
        clamp(v.x, min.x, max.x),
        clamp(v.y, min.y, max.y)
    )
end

function Vector.min(v1, v2)
    local x1, y1 = unpackOrSpread(v1)
    local x2, y2 = unpackOrSpread(v2)
    return Vector(
        math.min(x1, x2),
        math.min(y1, y2)
    )
end

function Vector.max(v1, v2)
    local x1, y1 = unpackOrSpread(v1)
    local x2, y2 = unpackOrSpread(v2)
    return Vector(
        math.max(x1, x2),
        math.max(y1, y2)
    )
end

function Vector.rotated(v, angle)
    local cos = math.cos(angle)
    local sin = math.sin(angle)
    return Vector(v.x * cos - v.y * sin, v.x * sin + v.y * cos)
end

-- Operator Implementations --

function Vector.__add(v1, v2)
    local x2, y2 = unpackOrSpread(v2)
    return Vector(v1.x + x2, v1.y + y2)
end

function Vector.__sub(v1, v2)
    local x2, y2 = unpackOrSpread(v2)
    return Vector(v1.x - x2, v1.y - y2)
end

function Vector.__mul(v1, v2)
    local x2, y2 = unpackOrSpread(v2)
    return Vector(v1.x * x2, v1.y * y2)
end

function Vector.__div(v1, v2)
    local x2, y2 = unpackOrSpread(v2)
    return Vector(v1.x / x2, v1.y / y2)
end

function Vector.__mod(v1, v2)
    local x2, y2 = unpackOrSpread(v2)
    return Vector(v1.x % x2, v1.y % y2)
end

function Vector.__unm(v)
    return Vector(-v.x, -v.y)
end

function Vector.__eq(v1, v2)
    return v1.x == v2.x and v1.y == v2.y
end

function Vector.__neq(v1, v2)
    return v1.x ~= v2.x or v1.y ~= v2.y
end

function Vector.__tostring(t)
    return string.format("Vector{%.4f, %.4f}", t.x, t.y)
end

function Vector.__concat(str, v)
    return tostring(str) .. tostring(v)
end

-- Type Check --

if ffi then
    function Vector.isVector(arg)
        return ffi.istype("shrimpvec", arg)
    end
else
    function Vector.isVector(arg)
        return type(arg) == VECTORTYPE and arg.x and arg.y
    end
end

-- Module End --

return Vector
