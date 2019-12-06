--    Game to ride a bicycle through a crowd of pedestrians safely
--    Copyright (C) 2019  Gavin Choy and Hui Taou Kok
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

    -- font size of 32 for the timer text
    timerFont = love.graphics.newFont(32)
    -- font size of 48 for the main menu and end of game
    mainFont = love.graphics.newFont(48)

    -- x and y position of player (the bicycle)
    playerx = 400
    playery = 550

    -- generate a new seed for the random number generator
    love.math.setRandomSeed(os.time())

    -- table of pedestrians coming from the left
    leftPedestrians = {}
    -- table of pedestrians coming from the right
    rightPedestrians = {}
    -- probability of a pedestrian spawning form each side per dt
    pedestrianProbability = 0.1

    -- table of all character images
    pedestrianCharacters = {}
    table.insert(pedestrianCharacters, love.graphics.newImage('Assets/Student1.png'))
    table.insert(pedestrianCharacters, love.graphics.newImage('Assets/Student2.png'))
    table.insert(pedestrianCharacters, love.graphics.newImage('Assets/Lecturer1.png'))
    table.insert(pedestrianCharacters, love.graphics.newImage('Assets/Lecturer2.png'))
    table.insert(pedestrianCharacters, love.graphics.newImage('Assets/Tourist1.png'))

    -- table of all other images
    images = {}
    images.bicycleImage = love.graphics.newImage('Assets/Bicycle.png')
    images.KingsCollege = love.graphics.newImage('Assets/King\'s College.jpg')
    images.CorpusClock = love.graphics.newImage('Assets/Corpus Clock.jpeg')
    images.KingsParadeText = love.graphics.newImage('Assets/King\'s Parade Text.png')

    -- table of sound effects
    soundEffects = {}
    soundEffects.crash = love.audio.newSource('Assets/Crash Large-SoundBible.com-2049318973.wav', 'static')
    soundEffects.bikeBell= love.audio.newSource('Assets/20191206-1715_Recording_3.wav', 'static')

end

-- update fields every dt time interval
function love.update(dt)

    -- when the game is playing
    if state == 'Game' then

        -- character movement by arrow keys
        if love.keyboard.isDown('right') then
            playerx = playerx + 1
        elseif love.keyboard.isDown('left') then
            playerx = playerx - 1
        elseif love.keyboard.isDown('up') then
            playery = playery - 1
        elseif love.keyboard.isDown('down') then
            playery = playery + 1
        end

        -- if the random number generator generates a number less than the probability set
        -- make a new pedestrian at a random position along the left
        if love.math.random() < pedestrianProbability then
            local pedestrian = {}
            pedestrian.x = 0
            pedestrian.y = love.math.random(0,500)

            table.insert(leftPedestrians, pedestrian)
        end

        -- if the random number generator generates a number less than the probability set
        -- make a new pedestrian at a random position along the left
        if love.math.random() < pedestrianProbability then
            local pedestrian = {}
            pedestrian.x = 750
            pedestrian.y = love.math.random(0,500)

            table.insert(rightPedestrians, pedestrian)
        end

        -- for each pedestrian from the left, move by 1 pixel towards the right
        for i = #leftPedestrians, 1, -1 do
            local pedestrian = leftPedestrians[i]
            pedestrian.x = pedestrian.x + 1
        end

        -- for each pedestrian from the right, move by 1 pixel towards the left
        for i = #rightPedestrians, 1, -1 do
            local pedestrian = rightPedestrians[i]
            pedestrian.x = pedestrian.x - 1
        end

    -- when in main menu
    elseif state == 'Main Menu' then

        -- start game by pressing the up arrow key
        if love.keyboard.isDown('up') then
            -- record when the game started
            startTime = os.time()
            state = 'Game'
        end
    end

end

function love.draw()

    -- in game
    if state == 'Game' then

        -- keep ringing the bike bell
        soundEffects.bikeBell:setLooping(true)
        soundEffects.bikeBell:play()

        -- draw pedestrian pavements
        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.rectangle('fill', 0, 0, 200, 1000)
        love.graphics.rectangle('fill', 700, 0, 200, 1000)
        love.graphics.setColor(1, 1, 1)
        -- draw features of the area
        love.graphics.draw(images.KingsCollege, 0, 200)
        love.graphics.draw(images.CorpusClock, 700, 450)
        love.graphics.draw(images.KingsParadeText, 300, 100)

        -- draw the player ()bicycle)
        love.graphics.draw(images.bicycleImage, playerx, playery)

        -- draw each pedestrian from the left
        for i = #leftPedestrians, 1, -1 do
            local pedestrian = leftPedestrians[i]
            love.graphics.draw(pedestrianCharacters[(i % #pedestrianCharacters) + 1], pedestrian.x, pedestrian.y)
        end

        -- draw each pedestrian from the right
        for i = #rightPedestrians, 1, -1 do
            local pedestrian = rightPedestrians[i]
            love.graphics.draw(pedestrianCharacters[(i % #pedestrianCharacters) + 1], pedestrian.x, pedestrian.y)
        end

        -- for each pedestrian from the left, detect if they have collided with the bike
        for i = #leftPedestrians, 1, -1 do
            local pedestrian = leftPedestrians[i]
            if collide(playerx, playery, pedestrian.x, pedestrian.y) then
                -- game lost
                lose = true
                -- play the crash sound effect
                soundEffects.crash:stop()
                soundEffects.crash:play()
                state = 'Finish'
            end
        end

        -- for each pedestrian from the right, detect if they have collided with the bike
        for i = #rightPedestrians, 1, -1 do
            local pedestrian = rightPedestrians[i]
            if collide(playerx, playery, pedestrian.x, pedestrian.y) then
                -- game lost
                lose = true
                -- play the crash sound effect
                soundEffects.crash:stop()
                soundEffects.crash:play()
                state = 'Finish'
            end
        end

        -- display timer at the top left of the viewport
        love.graphics.setFont(timerFont)
        love.graphics.print('Time left: ' .. duration - (os.time() - startTime))

        -- when the countdown reaches zero, game is lost
        if (duration - (os.time() - startTime)) <= 0 then
            lose = true
            state = 'Finish'
        end

        -- game won when the payer (bicycle) reaches the top of the viewport
        if playery == 0 then
            win = true
            state = 'Finish'
        end

    -- Display instructions on start
    elseif state == 'Main Menu' then
        love.graphics.setFont(mainFont)
        love.graphics.print('Press the up key to start')

    -- finish the game
    else
        -- stop the bike bell
        soundEffects.bikeBell:stop()
        love.graphics.setFont(mainFont)
        -- if game is won, print the winning message
        if win == true and lose == false then
            love.graphics.print('You won! Merry Bridgemas!')
        -- otherwise, display a losing message
        else
            love.graphics.print('You lost!')
            love.graphics.print('But, have a Merry Bridgemas!', 0, 100)
        end
    end

end