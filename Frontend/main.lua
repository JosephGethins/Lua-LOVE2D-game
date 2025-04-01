game_width, game_height = 320, 192
local canvas
local scale, offset_x, offset_y

function love.load()

    sti = require "libs/sti" 
    gameMap = sti("assets/maps/importmap.lua")
    wf = require "libs/windfield" 
    lg = love.graphics

    --love.window.setMode(0, 0, { fullscreen = true })  -- Set to fullscreen
    
    love.graphics.setDefaultFilter("nearest", "nearest")  -- Pixel-perfect

    --love.window.setMode(1280, 720, { resizable = true, fullscreen = false })
    --canvas = love.graphics.newCanvas(game_width, game_height)
    --love.resize(love.graphics.getWidth(), love.graphics.getHeight()) -- Initialize scaling
    
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
    player.maxJumpForce = 1200
    player.scale = 0.5

    world = wf.newWorld(0,1000) -- (x , y ) y postive value is downwards
    player.collider = world:newRectangleCollider(player.x, player.y, 20, 40) -- Create a rectangle collider for the player
    player.collider:setFriction(50)  -- Apply moderate friction to prevent sliding
    --player.collider:setLinearDamping(5)  -- Apply damping to slow down movement
    player.collider:setFixedRotation(true)
    ground = world:newRectangleCollider(0, 500, 1000, 8) -- Create a rectangle collider for the ground
    ground:setType('static') -- Set the ground collider to static


    
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
    world:draw()
    love.graphics.draw(player.image, player.x, player.y,0, player.scale, player.scale)
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

function love.resize(w, h)
    local scale_x = w / game_width
    local scale_y = h / game_height
    scale = math.min(scale_x, scale_y) -- Maintain aspect ratio

    -- Compute the letterbox (black bars)
    offset_x = (w - game_width * scale) / 2
    offset_y = (h - game_height * scale) / 2
end

