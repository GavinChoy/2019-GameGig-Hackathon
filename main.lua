require 'objectCollision'

function love.load()

    state = 'Main Menu'

    duration = 30

    lose = false
    win = false

    love.graphics.setBackgroundColor(0.3, 0.3, 0.3)

    timerFont = love.graphics.newFont(32)
    mainFont = love.graphics.newFont(64)

    playerx = 400
    playery = 550

    love.math.setRandomSeed(os.time())

    leftPedestrians = {}
    rightPedestrians = {}
    pedestrianProbability = 0.1

end

function love.update(dt)

    if state == 'Game' then

        if love.keyboard.isDown('right') then
            playerx = playerx + 1
        elseif love.keyboard.isDown('left') then
            playerx = playerx - 1
        elseif love.keyboard.isDown('up') then
            playery = playery - 1
        elseif love.keyboard.isDown('down') then
            playery = playery + 1
        end

        if love.math.random() < pedestrianProbability then
            local pedestrian = {}
            pedestrian.x = 0
            pedestrian.y = love.math.random(0,500)

            table.insert(leftPedestrians, pedestrian)
        end

        if love.math.random() < pedestrianProbability then
            local pedestrian = {}
            pedestrian.x = 750
            pedestrian.y = love.math.random(0,500)

            table.insert(rightPedestrians, pedestrian)
        end

        for i = #leftPedestrians, 1, -1 do
            local pedestrian = leftPedestrians[i]
            pedestrian.x = pedestrian.x + 1
        end

        for i = #rightPedestrians, 1, -1 do
            local pedestrian = rightPedestrians[i]
            pedestrian.x = pedestrian.x - 1
        end

    elseif state == 'Main Menu' then
        if love.keyboard.isDown('up') then
            startTime = os.time()
            state = 'Game'
        end
    end

end

function love.draw()

    if state == 'Game' then

        love.graphics.rectangle('fill', playerx, playery, 20, 20)

        for i = #leftPedestrians, 1, -1 do
            local pedestrian = leftPedestrians[i]
            love.graphics.rectangle('fill', pedestrian.x, pedestrian.y, 10, 10)
        end

        for i = #rightPedestrians, 1, -1 do
            local pedestrian = rightPedestrians[i]
            love.graphics.rectangle('fill', pedestrian.x, pedestrian.y, 10, 10)
        end

        for i = #leftPedestrians, 1, -1 do
            local pedestrian = leftPedestrians[i]
            if collide(playerx, playery, pedestrian.x, pedestrian.y) then
                lose = true
                state = 'Finish'
            end
        end

        for i = #rightPedestrians, 1, -1 do
            local pedestrian = rightPedestrians[i]
            if collide(playerx, playery, pedestrian.x, pedestrian.y) then
                lose = true
                state = 'Finish'
            end
        end

        love.graphics.setFont(timerFont)
        love.graphics.print(duration - (os.time() - startTime))

        if (duration - (os.time() - startTime)) <= 0 then
            lose = true
            state = 'Finish'
        end

        if playery == 0 then
            win = true
            state = 'Finish'
        end

    elseif state == 'Main Menu' then
        love.graphics.setFont(mainFont)
        love.graphics.print('Press the up key to start')

    else
        love.graphics.setFont(mainFont)
        if win == true and lose == false then
            love.graphics.print('You won!')
        elseif lose == true then
            love.graphics.print('You lost!')
        end
    end

end