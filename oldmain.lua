require 'objectCollision'

function love.load()

    lose = false
    win = false

    startTime = os.time()
    duration = 5

    love.graphics.setBackgroundColor(0.3, 0.3, 0.3)

    playerx = 400
    playery = 550

    love.math.setRandomSeed(os.time())

    leftBicycles = {}
    rightBicycles = {}

end

function love.update(dt)

    if love.keyboard.isDown('right') then
        playerx = playerx + 1
    elseif love.keyboard.isDown('left') then
        playerx = playerx - 1
    elseif love.keyboard.isDown('up') then
        playery = playery - 1
    elseif love.keyboard.isDown('down') then
        playery = playery + 1
    end

    if love.math.random() < 0.1 then
        local bicycle = {}
        bicycle.x = 0
        bicycle.y = love.math.random(0,500)

        table.insert(leftBicycles, bicycle)
    end

    if love.math.random() < 0.1 then
        local bicycle = {}
        bicycle.x = 750
        bicycle.y = love.math.random(0,500)

        table.insert(rightBicycles, bicycle)
    end

    for i = #leftBicycles, 1, -1 do
        local bicycle = leftBicycles[i]
        bicycle.x = bicycle.x + 2
    end

    for i = #rightBicycles, 1, -1 do
        local bicycle = rightBicycles[i]
        bicycle.x = bicycle.x - 2
    end

end

function love.draw()

    love.graphics.rectangle('fill', playerx, playery, 20, 20)

    for i = #leftBicycles, 1, -1 do
        local bicycle = leftBicycles[i]
        love.graphics.rectangle('fill', bicycle.x, bicycle.y, 10, 10)
    end

    for i = #rightBicycles, 1, -1 do
        local bicycle = rightBicycles[i]
        love.graphics.rectangle('fill', bicycle.x, bicycle.y, 10, 10)
    end

    for i = #leftBicycles, 1, -1 do
        local bicycle = leftBicycles[i]
        if collide(playerx, playery, bicycle.x, bicycle.y) then
            lose = true
        end
    end

    for i = #rightBicycles, 1, -1 do
        local bicycle = rightBicycles[i]
        if collide(playerx, playery, bicycle.x, bicycle.y) then
            lose = true
        end
    end

    love.graphics.print(duration - (os.time() - startTime))

    if (duration - (os.time() - startTime)) <= 0 then
        lose = true
    end

    if playery == 0 then
        win = true
    end

    if lose == true then
        love.graphics.print('LOSE')
    end

   if win == true then
        love.graphics.print('WIN')
   end

end