-- import objectCollision.lua
require 'objectCollision'

-- load the following on startup of game
function love.load()

    -- states are: Main Menu, Game and Finish
    state = 'Main Menu'

    -- duration of game time in seconds
    -- sets countdown timer
    duration = 30

    -- has not won or lost the game yet
    lose = false
    win = false

    -- set background colour to grey
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)


    timerFont = love.graphics.newFont(32)
    mainFont = love.graphics.newFont(64)

    playerx = 400
    playery = 550

    love.math.setRandomSeed(os.time())

    leftPedestrians = {}
    rightPedestrians = {}
    pedestrianProbability = 0.1

    pedestrianCharacters = {}
    table.insert(pedestrianCharacters, love.graphics.newImage('Assets/Student1.png'))
    table.insert(pedestrianCharacters, love.graphics.newImage('Assets/Student2.png'))
    table.insert(pedestrianCharacters, love.graphics.newImage('Assets/Lecturer1.png'))
    table.insert(pedestrianCharacters, love.graphics.newImage('Assets/Lecturer2.png'))
    table.insert(pedestrianCharacters, love.graphics.newImage('Assets/Tourist1.png'))

    bicycleImage = love.graphics.newImage('Assets/Bicycle.png')
    KingsCollege = love.graphics.newImage('Assets/King\'s College.jpg')
    CorpusClock = love.graphics.newImage('Assets/Corpus Clock.jpeg')
    KingsParadeText = love.graphics.newImage('Assets/King\'s Parade Text.png')

    soundEffects = {}
    soundEffects.crash = love.audio.newSource('Assets/Crash Large-SoundBible.com-2049318973.wav', 'static')
    soundEffects.bikeBell= love.audio.newSource('Assets/20191206-1715_Recording_3.wav', 'static')

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

        soundEffects.bikeBell:setLooping(true)
        soundEffects.bikeBell:play()

        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.rectangle('fill', 0, 0, 200, 1000)
        love.graphics.rectangle('fill', 700, 0, 200, 1000)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(KingsCollege, 0, 200)
        love.graphics.draw(CorpusClock, 700, 450)
        love.graphics.draw(KingsParadeText, 300, 100)

        love.graphics.draw(bicycleImage, playerx, playery)

        for i = #leftPedestrians, 1, -1 do
            local pedestrian = leftPedestrians[i]
            love.graphics.draw(pedestrianCharacters[(i % #pedestrianCharacters) + 1], pedestrian.x, pedestrian.y)
        end

        for i = #rightPedestrians, 1, -1 do
            local pedestrian = rightPedestrians[i]
            love.graphics.draw(pedestrianCharacters[(i % #pedestrianCharacters) + 1], pedestrian.x, pedestrian.y)
        end

        for i = #leftPedestrians, 1, -1 do
            local pedestrian = leftPedestrians[i]
            if collide(playerx, playery, pedestrian.x, pedestrian.y) then
                lose = true
                soundEffects.crash:stop()
                soundEffects.crash:play()
                state = 'Finish'
            end
        end

        for i = #rightPedestrians, 1, -1 do
            local pedestrian = rightPedestrians[i]
            if collide(playerx, playery, pedestrian.x, pedestrian.y) then
                lose = true
                soundEffects.crash:stop()
                soundEffects.crash:play()
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
        soundEffects.bikeBell:stop()
        love.graphics.setFont(mainFont)
        if win == true and lose == false then
            love.graphics.print('You won!')
        elseif lose == true then
            love.graphics.print('You lost!')
        end
    end

end