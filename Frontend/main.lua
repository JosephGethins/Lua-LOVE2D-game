base_width, base_height = 320*3, 180*3 
local scaleX = 3
local scaleY = 3

function love.load()

    love.window.setMode(320*scaleX, 180*scaleY)--{fullscreen = true, resizable = false})  -- Set the window size

    sti = require "libs/sti" 
    gameMap = sti("assets/maps/importmap.lua")
    wf = require "libs/windfield" 
    camera = require "libs/camera"
    lg = love.graphics

    cam = camera()
    --window_width, window_height = love.graphics.getDimensions()
    --local scaleX = window_width / game_width
    --local scaleY = window_height / game_height
    --cameraScale = math.min(scaleX, scaleY) -- Maintain aspect ratio
    --love.window.setMode(game_width, game_height) -- Adjust scaling factor as needed
 
    world = wf.newWorld(0,1000) -- (x , y ) y postive value is downwards

    player = {} -- Create a table to hold player information    player:setFixedRotation(true) -- Prevent unwanted rotations
    player.image = love.graphics.newImage("assets/player/sprite.JPG")
    player.width = player.image:getWidth()
    player.height = player.image:getHeight()
    player.x = 100 -- Set the player's x position
    player.y = 100 -- Set the player's y position
    player.speed = 200 -- Set the player's speed
    player.isCharging = false
    player.chargeTime = 0
    player.maxCharge = 1 -- Max charge duration (1 second)
    player.jumpForce = 300
    player.maxJumpForce = 900
    player.scale = 0.5
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 20, 40, 15) -- Create a rectangle collider for the player
    player.collider:setFriction(50)  -- Apply moderate friction to prevent sliding
    --player.collider:setLinearDamping(5)  -- Apply damping to slow down movement
    player.collider:setFixedRotation(true)

    walls = {}
    if gameMap.layers["walls"] then
        for i,  obj in pairs(gameMap.layers["walls"].objects) do

            local scaledX = obj.x * scaleX
            local scaledY = obj.y * scaleY
            local scaledWidth = obj.width * scaleX
            local scaledHeight = obj.height * scaleY

            local wall = world:newRectangleCollider(scaledX, scaledY, scaledWidth, scaledHeight)
            wall:setType('static') 
            table.insert(walls, wall) -- Add the wall collider to the walls table
        end
    end

    love.graphics.setDefaultFilter("nearest", "nearest")  -- Pixel-perfect
end

function love.update(dt)

    world:update(dt)
    
    player.x = player.collider:getX() - player.width / 2 -- so we get centre from x side and y side below to find tru centre of sprite
    player.y = player.collider:getY() - player.height / 2 -- so we get centre from x side and y side below to find tru centre of sprite
    
    
    if love.keyboard.isDown("space") and isGrounded then
       player.isCharging = true
       player.chargeTime = math.min(player.chargeTime + dt, player.maxCharge) -- Increase charge time, but clamp to max charge
    end


end

function love.draw()


    cam:attach()
        love.graphics.push() 
        love.graphics.scale(scaleX, scaleY)  -- Scale everything
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"],base_width,base_height) 
        gameMap:drawLayer(gameMap.layers["lowest layer behind effects"],base_width,base_height) 
        gameMap:drawLayer(gameMap.layers["lowest layer"],base_width,base_height) 
        love.graphics.pop()
        world:draw() -- wireframes for all the hitboxes
        love.graphics.draw(player.image, player.x, player.y,0, player.scale, player.scale)
    cam:detach()

end

function isGrounded()
    local colliders = world:queryRectangleArea(player.collider:getX() - 10, player.collider:getY() + 10, 20, 2)
    return #colliders
end

function love.keyreleased(key)
    if key == "space" and player.isCharging then
        local jumpStr = player.jumpForce + (player.chargeTime / player.maxCharge) * (player.maxJumpForce - player.jumpForce) -- this is calulcating the scale of the jump (I thhink)
        local  sideJumpStr = player.jumpForce + (player.chargeTime / player.maxCharge) * player.jumpForce
        player.collider:applyLinearImpulse(0, -jumpStr)

        if love.keyboard.isDown("d") then
            player.collider:applyLinearImpulse(sideJumpStr,0)
        elseif love.keyboard.isDown("a") then
            player.collider:applyLinearImpulse(-sideJumpStr,0)
        end

        player.chargeTime = 0
        player.isCharging = false
    end
end

function resolution()
    local window_width = game_width * 2
    local window_height = game_height * 2 -- for 720p apparently
end

