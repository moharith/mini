-- todo 
-- main menu CHECK
-- bug yellow green (2nd letter) CHECK
-- background music
-- better word list CHECK
-- graphics
-- font


-- constants
WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
WORD_LENGTH = 5
GRID_MAX_HEIGHT = 5 
GRID_SIZE = 40
GRIDSIZE_DRAW = 38
FONT_SIZE = 20
MENU_HEIGHT = 30

local place = 1

local Word = "prima"

local SelectX, SelectY = 1 ,1 
local GameState = 'playing'

function love.load()
    font = love.graphics.newFont(FONT_SIZE)
    game_reset()
end

function game_reset()
    -- init
    SelectX, SelectY = 1 ,1 
    score = 0

    -- clear tables
    WordTable = {} -- table with all the words (within word_length) from list
    WordStorage = {} -- word (divided into characters)
    Grid = {} -- grid
    menu = {} -- menu list

    -- build wordlist

    for line in love.filesystem.lines("basiswoorden-gekeurd.txt") do
        if string.len(line) == WORD_LENGTH then 
            -- here maybe check for dirty characters..
            table.insert(WordTable,string.upper(line))
        end
    end

    -- select random word from wordlist
    randomNumber = love.math.random(1, #WordTable)
    Word = WordTable[randomNumber]

    -- divide word into characters

    for i = 1, WORD_LENGTH do -- save word 
        table.insert(WordStorage,
            {character = string.sub(Word,i,i),})
    end

    -- build grid
    print(Word)

    for y = 1, GRID_MAX_HEIGHT do
        Grid[y] = {}
        for x = 1, WORD_LENGTH do
            Grid[y][x] = {
                content = ' ', -- letter space
                flag = 'neutral' -- flag
            }            
        end
    end

    -- build menu 
        
   
    for y = 1, 3 do
        menu[y] = { 
        text = " ",
        select = false
        }
    end
    menu[1].select = true
    GameState = 'main'

end

function new_game()
    Word = WordTable[randomNumber]

    for i = 1, WORD_LENGTH do -- save word 
        table.insert(WordStorage,
            {character = string.sub(Word,i,i),})
    end

    for y = 1, GRID_MAX_HEIGHT do
        Grid[y] = {}
        for x = 1, WORD_LENGTH do
            Grid[y][x] = {
                content = ' ', -- letter space
                flag = 'neutral' -- flag
            }            
        end
    end

end

function love.keypressed(key)

    if key == 'escape' then

        if GameState ~= 'main' 
            then GameState = 'main'

        else
        love.event.quit()
        end

    elseif key == 'left' then 

        if GameState == 'main' then
            if place == 2 and WORD_LENGTH > 3 then 
                WORD_LENGTH = WORD_LENGTH - 1
            elseif place == 3 and GRID_MAX_HEIGHT > 3 then 
                GRID_MAX_HEIGHT = GRID_MAX_HEIGHT - 1 
            end               
            
        else

            if SelectX > 1 then 
                SelectX = SelectX - 1
            end
        end

    elseif key == 'right' then 

        if GameState == 'main' then
            if place == 2 and WORD_LENGTH < 10 then 
                WORD_LENGTH = WORD_LENGTH + 1
                print(WORD_LENGTH)
            elseif place == 3 and GRID_MAX_HEIGHT < 10 then 
                GRID_MAX_HEIGHT = GRID_MAX_HEIGHT + 1                
            
            end

        else

            if SelectX < WORD_LENGTH then
            SelectX = SelectX + 1
            end
        end
    
    elseif key == 'down' then
        if GameState == 'main' then
            menu[place].select = false
            if place > 0 then 
                if place ~= 3 then
                    place = place + 1
                else  
                    place = 1
                end
            end
            menu[place].select = true
        end

    elseif key == 'up' then
        if GameState == 'main' then
            menu[place].select = false
            if place > 1 then 
                place = place - 1
            else
                place = 3
            end
            menu[place].select = true
        end

    elseif key == 'backspace' or key == 'delete' then
        Grid[SelectY][SelectX].content = " "
        if SelectX > 1 then
            SelectX = SelectX - 1
        end

    elseif key == 'return' then
        -- return

        if GameState == 'playing' then

            local wordscore = 0

            for pos = 1, WORD_LENGTH do
            

                -- check if letter is on correct position

                if Grid[SelectY][pos].content == WordStorage[pos].character then
                    Grid[SelectY][pos].flag = 'correct'
                    print(Grid[SelectY][pos].flag .. pos)
                    wordscore = wordscore + 1
                        if wordscore == WORD_LENGTH then
                            GameState = 'won'
                        end

                end

                for p = 1, WORD_LENGTH do -- check letter is within WordStorage [1 to ..] -- only if not correct.
                    if  Grid[SelectY][p].flag ~= 'correct' and Grid[SelectY][p].content == WordStorage[pos].character then 
                        Grid[SelectY][p].flag = 'possible' -- Flag the Grid
                    end      
                end
            end

            SelectY = SelectY + 1
            SelectX = 1

            if SelectY > GRID_MAX_HEIGHT then
                GameState = 'gameover'
            end

            --

        if GameState == 'won' then

            new_game()

        end

        else
            game_reset()
            GameState = 'playing'

        end

        -- characters

    elseif key:match('^%a$') then --letters
                Grid[SelectY][SelectX].content = string.upper(key)
                if SelectX < WORD_LENGTH then 
                    SelectX = SelectX + 1
                end
    end
end

-- function love.update(dt)

-- end

function love.draw()
    love.graphics.setFont(font)

    if GameState == 'main' then
        main_menu()
    end

    if GameState == 'playing' then
            
        for y = 1, GRID_MAX_HEIGHT do
            for x = 1, WORD_LENGTH do
                
                -- set flags

                if Grid[y][x].flag == 'neutral' then
                    love.graphics.setColor(1,1,1,0.5)

                elseif Grid[y][x].flag == 'possible' then
                    love.graphics.setColor(1,1,0,0.7)
                end
                                
                if Grid[y][x].flag == 'correct' then

                    Grid[y+1][x].content = Grid[y][x].content 
                    love.graphics.setColor(0,.87,0,0.7)
                end


                -- draw box

                love.graphics.rectangle('fill',(WINDOW_WIDTH / 3) + x * GRID_SIZE,y * GRID_SIZE,GRIDSIZE_DRAW,GRIDSIZE_DRAW) 

                -- draw text
                
                love.graphics.setColor(1,1,1,1)
                love.graphics.print(tostring(Grid[y][x].content ), ((WINDOW_WIDTH / 3) +x * GRID_SIZE) + GRID_SIZE / 4 , (y * GRID_SIZE) + GRID_SIZE /4) 
          
                -- draw score

                love.graphics.print('score: ' .. score)
            end


        end    
        
        love.graphics.setColor(1,1,1,0.3)
        love.graphics.rectangle('fill', ((WINDOW_WIDTH / 3) + SelectX * GRID_SIZE), (SelectY * GRID_SIZE), GRIDSIZE_DRAW, GRIDSIZE_DRAW )
    elseif GameState == 'won' then
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf('Je hebt gewonnen',(WINDOW_WIDTH / 2) - font:getWidth('You Won'), (WINDOW_HEIGHT / 2)  , 125, "center")
        love.graphics.printf('Druk op enter om een volgend woord te spelen', (WINDOW_WIDTH / 3) - 100, (WINDOW_HEIGHT / 3)  , 400, "center")

    elseif GameState == 'gameover' then
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf('Je hebt verloren',(WINDOW_WIDTH / 2) - font:getWidth('You Won'), (WINDOW_HEIGHT / 2)  , 125, "center")
    end
end


function main_menu()

    love.graphics.setColor(1,1,1,1)


    love.graphics.rectangle('line', WINDOW_WIDTH * .1, WINDOW_HEIGHT * .1, WINDOW_WIDTH * .8, WINDOW_HEIGHT * .8)
    love.graphics.printf('Welkom bij Wurdle',(WINDOW_WIDTH / 3)  , (WINDOW_HEIGHT / 4)  , 250, "center")
    love.graphics.printf('Gemaakt door Jordi de Geus',(WINDOW_WIDTH / 3)  , (WINDOW_HEIGHT / 3) , 250, "center")


 
    menu[1].text = 'Nieuw spel' 
    menu[2].text = 'Woordlengte: ' .. WORD_LENGTH
    menu[3].text = 'Aantal Rijen: ' .. GRID_MAX_HEIGHT

    for y = 1 , 3 do

        if menu[y].select == true then 
            love.graphics.setColor(1,1,0,0.8) 
        elseif menu[y].select == false then 
            love.graphics.setColor(1,1,1,1)    
        end        


        love.graphics.printf(menu[y].text,(WINDOW_WIDTH / 3)  , (y + 10) * MENU_HEIGHT ,250, "center")
    end







end
