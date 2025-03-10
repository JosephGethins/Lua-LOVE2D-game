function love.load()
    -- Load your map or other resources here
    -- Example: mygame/maps/map_name
    player = {} -- Create a table to hold player information
    player.x = 100 -- Set the player's x position
    player.y = 100 -- Set the player's y position
    player.speed = 100 -- Set the player's speed
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
end

function love.draw()
    -- Draw your game elements here
    love.graphics.rectangle('fill', player.x, player.y, 50, 50)
end