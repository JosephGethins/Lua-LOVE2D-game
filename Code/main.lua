function love.load()
    -- Load your map or other resources here
    -- Example: mygame/maps/map_name
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
    -- Draw your game elements here
    love.graphics.rectangle('fill', player.x, player.y, 50, 50)
end
