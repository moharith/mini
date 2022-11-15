-- constants
WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
WORD_LENGTH = 8
GRID_MAX_HEIGHT = 5 
GRID_SIZE = 40
GRIDSIZE_DRAW = 38
FONT_SIZE = 20

local Word = "prima"
local WordTable = {}
local SelectX, SelectY = 1 ,1 
local GameState = 'playing'

function love.load()
    -- READ WORDLIST
    for line in love.filesystem.lines("wordlist.txt") do
        if string.len(line) == WORD_LENGTH then 
            table.insert(WordTable,string.upper(line))
        end
    end

    font = love.graphics.newFont(FONT_SIZE)
    game_reset()
end

function game_reset()
    WordStorage = { }
    Grid = {}

    randomNumber = love.math.random(1, #WordTable)
    Word = WordTable[randomNumber]
    print(Word)

    SelectX, SelectY = 1 ,1 

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
        love.event.quit()

    elseif key == 'left' then 

        if SelectX > 1 then 
            SelectX = SelectX - 1
        end

    elseif key == 'right' then 

        if SelectX < GRID_MAX then
           SelectX = SelectX + 1
        end

    elseif key == 'backspace' then
        SelectX = SelectX - 1
        Grid[SelectY][SelectX].content = " "
        
    elseif key == 'return' then
        -- return

        if GameState == 'playing' then

            local wordscore = 0

            for pos = 1, WORD_LENGTH do
                for p = 1, WORD_LENGTH do -- check letter '1 to 5' is within WordStorage [1 to 5]
                    if Grid[SelectY][p].content == WordStorage[pos].character then 
                        Grid[SelectY][p].flag = 'possible' -- Flag the Grid
                    end      
                end

                -- check if letter is on correct position

                if Grid[SelectY][pos].content == WordStorage[pos].character then
                    Grid[SelectY][pos].flag = 'correct'
                    wordscore = wordscore + 1
                        if wordscore == WORD_LENGTH then
                            GameState = 'won'
                        end

                end
            end

            SelectY = SelectY + 1
            SelectX = 1

            if SelectY > GRID_MAX_HEIGHT then
                GameState = 'gameover'
            end

        else
            game_reset()
            GameState = 'playing'

        end

        -- characters

    elseif key:match('^%a$') then --letters
                LaatsteToets = string.byte(key)
                Grid[SelectY][SelectX].content = string.upper(key)
                if SelectX < WORD_LENGTH then 
                    SelectX = SelectX + 1
                end
         --   end
    --    end
            
   --     end
    end
end

function love.update(dt)

end

function love.draw()
    love.graphics.setFont(font)

    if GameState == 'playing' then
            
        for y = 1, GRID_MAX_HEIGHT do
            for x = 1, WORD_LENGTH do
                
                -- set flags

                if Grid[y][x].flag == 'neutral' then
                    love.graphics.setColor(1,1,1,0.5)

                elseif Grid[y][x].flag == 'possible' then
                    love.graphics.setColor(1,1,0,0.7)
                                
                elseif Grid[y][x].flag == 'correct' then
                    love.graphics.setColor(0,.87,0,0.7)

                end

                -- draw box

                love.graphics.rectangle('fill',x * GRID_SIZE,y * GRID_SIZE,GRIDSIZE_DRAW,GRIDSIZE_DRAW) 

                -- draw text
                
                love.graphics.setColor(1,1,1,1)
                love.graphics.print(tostring(Grid[y][x].content), (x * GRID_SIZE) + GRID_SIZE / 4 , (y * GRID_SIZE) + GRID_SIZE /4) 
          

            end


        end    
        
        love.graphics.setColor(1,1,1,0.3)
        love.graphics.rectangle('fill', (SelectX * GRID_SIZE), (SelectY * GRID_SIZE), GRIDSIZE_DRAW, GRIDSIZE_DRAW )
    elseif GameState == 'won' then
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf('Je hebt gewonnen',(WINDOW_WIDTH / 2) - font:getWidth('You Won'), (WINDOW_HEIGHT / 2)  , 125, "center")
    elseif GameState == 'gameover' then
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf('Je hebt verloren',(WINDOW_WIDTH / 2) - font:getWidth('You Won'), (WINDOW_HEIGHT / 2)  , 125, "center")
    end
end

