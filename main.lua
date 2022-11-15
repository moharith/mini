WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

WORD_LENGTH = 5

GRID_MAX = 5
GRID_SIZE = 20
GRIDSIZE_DRAW = 19

local Word = "prima"
local WordTable = {}
local SelectX, SelectY = 1 ,1 
local win = false

alphabet = {}


 
function love.load()

    for num = 97, 122 do
        table.insert(alphabet, string.char(num)) 
    end


    -- READ WORDLIST
    for line in love.filesystem.lines("wordlist.txt") do
        if string.len(line) == WORD_LENGTH then 
            table.insert(WordTable,string.upper(line))
        end
    end

    font = love.graphics.newFont(18)
    game_reset()

end

function game_reset()
    WordStorage = { }
    Grid = {}

    randomNumber = love.math.random(1, #WordTable)
    Word = WordTable[randomNumber]
    print(Word)

    SelectX, SelectY = 1 ,1 

    GuessedWord = { 
        {" ", " ", " ", " ", " " }, --1
        {" ", " ", " ", " ", " " }, --2
        {" ", " ", " ", " ", " " },
        {" ", " ", " ", " ", " " },
        {" ", " ", " ", " ", " " },
    }

    for i = 1, WORD_LENGTH do
        table.insert(WordStorage,
        {
            ichar = string.sub(Word,i,i),

            correct = false
        }
    
    
    )
    print(Word)
    end
    
    for y = 1, GRID_MAX do
        Grid[y] = {}
        for x = 1, GRID_MAX do
            Grid[y][x] = {
                block = ' ',
                flag = 'neutral'
            }            
        end
    end

end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    end

    if key == 'left' then 

        if SelectX > 1 then 
            SelectX = SelectX - 1
        end

    elseif key == 'right' then 

        if SelectX < GRID_MAX then
           SelectX = SelectX + 1
        end

    elseif key == 'backspace' then
        SelectX = SelectX - 1
        GuessedWord[SelectY][SelectX] = " "
        
    elseif key == 'return' then
        -- return

        if not win then

            local wordscore = 0
            for pos = 1, 5 do
                for p = 1, 5 do -- check letter '1 to 5' is within WordStorage [1 to 5]
                    if GuessedWord[SelectY][p] == WordStorage[pos].ichar then
                        Grid[SelectY][p].flag = 'possible' -- Flag the Grid
                    end      
                end

                -- check if letter is on correct position

                if GuessedWord[SelectY][pos] == WordStorage[pos].ichar then
                    Grid[SelectY][pos].flag = 'correct'
                    wordscore = wordscore + 1
                        if wordscore == 5 then
                            print('WON')
                            win = true
                        end

                end
            end
            SelectY = SelectY + 1
            SelectX = 1

        else
            game_reset()
            win = false

        end


        -- characters

    elseif 
      --  for k = 1, #alphabet do 
             key == alphabet[1] then --string.byte(key) > 96 and string.byte(key) < 123 or string.len(key) > 1 then 
                print(key)
                LaatsteToets = string.byte(key)
                GuessedWord[SelectY][SelectX] = string.upper(key)
                SelectX = SelectX + 1
            
   --     end
    end
end

function love.update(dt)

end

function love.draw()

    if win == false then
            
        for y = 1, GRID_MAX do
            for x = 1, GRID_MAX do
                
                if Grid[y][x].flag == 'neutral' then
                    love.graphics.setColor(1,1,1,0.5)

                elseif Grid[y][x].flag == 'possible' then
                    love.graphics.setColor(1,1,0,0.7)
                                
                elseif Grid[y][x].flag == 'correct' then
                    love.graphics.setColor(0,.87,0,0.7)

                end
                
                love.graphics.rectangle('fill',x * GRID_SIZE,y * GRID_SIZE,GRIDSIZE_DRAW,GRIDSIZE_DRAW)                  

            end
        end    

        for y=1 , 5 do
            for x = 1, 5 do
                love.graphics.setColor(1,0,0,1)
                love.graphics.print(tostring(GuessedWord[y][x]), (x * GRID_SIZE) + GRID_SIZE / 4 , (y * GRID_SIZE)) 
            end
        end
        
        love.graphics.setColor(1,1,1,0.3)
        love.graphics.rectangle('fill', (SelectX * GRID_SIZE), (SelectY * GRID_SIZE), GRIDSIZE_DRAW, GRIDSIZE_DRAW )
    else
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf('You Won',(WINDOW_WIDTH / 2) - font:getWidth('You Won'), (WINDOW_HEIGHT / 2)  , 125, "center")
    end




         

end

