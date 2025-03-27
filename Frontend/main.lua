function love.load()

    sti = require "libs/sti" 
    push = require "libs/push" -- Import the push library for screen scaling
    gameMap = sti("assets/maps/importmap.lua")

    -- love.window.setMode(0, 0, { fullscreen = true })  -- Set to fullscreen
    
    window_width, window_height = love.graphics.getDimensions() -- Get the window dimensions
    window_width = window_width * 0.5 -- Set the window width to half of the screen width
    window_height = window_height * 0.5 -- Set the window height to half of the screen height

    virtual_width = 320
    virtual_height = 180


    push:setupScreen(virtual_width, virtual_height, window_width, window_height, {fullscreen = false, vsync = true}) -- Set up the screen with push
    
    
    
    
    love.graphics.setDefaultFilter("nearest", "nearest")  -- Pixel-perfect


    player = {} -- Create a table to hold player information
    player.x = 100 -- Set the player's x position
    player.y = 100 -- Set the player's y position
    player.speed = 200 -- Set the player's speed
    jumpCharge = 0 -- Initialises the jumpCharge at zero
    player.jumpChargeIncrease = 5 --Sets the rate of increase of jumpCharge
    player.chargeLimit = 500 -- Sets the charge limit for jumpCharge
    player.minJump = 200


end

function love.update(dt)
    -- Update your game state here
    if love.keyboard.isDown('w') then
        player.y = player.y -  player.speed * dt
    end
    if love.keyboard.isDown('a') then
        player.x = player.x -  player.speed * dt
    end
    if love.keyboard.isDown('s') then
        player.y = player.y +  player.speed * dt
    end
    if love.keyboard.isDown('d') then
        player.x = player.x +  player.speed * dt
    end

    if love.keyboard.isDown("space") then
        if jumpCharge > 1 and jumpCharge < 100 then 
            jumpCharge = player.minJump     -- ( a minimum jump distance for a short press)
        end
        jumpCharge = jumpCharge + player.jumpChargeIncrease
        if jumpCharge >= player.chargeLimit then -- sets a limit on the maximum jumpCharge
            jumpCharge = player.chargeLimit
        end
    else
        if jumpCharge > 0 then
            player.y = player.y - jumpCharge * dt
            jumpCharge = jumpCharge - 5
        end
    end
end

function love.draw()

    push:start()
        gameMap:draw()
    push:finish()
    love.graphics.rectangle('fill', player.x, player.y, 50, 50)

end
