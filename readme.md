# Template

Love2D Template for and by Nyatalily.

# Usage

This template provides an extra layer of callbacks above what Love2D provides natively:
- [love.load] `lovely.load`
    - Regular love load method
- [love.update] `lovely.updateFixed` 
    - Called at a fixed update rate, potentially multiple times per `love.update`
    - Can be configured setting `lovely.fixedTimer.fixedDelta`
- [love.update] `lovely.update` 
    - Called after `lovely.updateFixed` 
    - Regular `love.update` method
- [love.update] `lovely.framePrepare` 
    - Called after `lovely.update`
    - Intended to allow you to prepare/finalize graphical elements after processing all game logic
- [love.draw] `lovely.frameDraw` 
    - Regular `love.draw` method

The entry point for the game's actual code is [`project/src/game.lua`](project/src/game.lua)

# License 

This repository is released under the terms of its constituent parts, if
there is a part you are not using then you may remove it and its terms.

# Tools

## Love2D
This project uses Love2D, it includes prerelease appimages of Love2D 12.0 in the [scripts/bin/](scripts/bin/) directory of the repository. Love2D itself is used and provided under the zlib license, but the full Love2D licensing information is [provided here.](/home/nya/Dev/project/l2d_lifeafter/scripts/bin/love_license.txt)

## Libraries
- [[MIT] Shove - A resolution-handling and rendering library for LÖVE](https://github.com/Oval-Tutu/shove/tree/main)
- [[MIT] Middleclass - Object Orientation for Lua](https://github.com/kikito/middleclass)
- [[MIT] Evolved - ECS (Entity-Component-System) for Lua](https://github.com/BlackMATov/evolved.lua)
- [[MIT] Beholder - A simple event observer for Lua](https://github.com/kikito/beholder.lua)
- [[MIT] Brinevector (heavily modified, "shrimpvec") - A 2D vector library that makes use of ffi when availiable](https://github.com/novemberisms/brinevector)
    - [Modified Version Here](/project/lib/shrimpvec.lua)
- [[MIT] log.lua - A tiny logging module for Lua.](https://github.com/rxi/log.lua)

