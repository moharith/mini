Word = "prima"

WordStorage = { }

GuessedWord = { 
    {" ", " ", " ", " ", " " }, --1
    {" ", " ", " ", " ", " " }, --2
    {" ", " ", " ", " ", " " },
    {" ", " ", " ", " ", " " },
    {" ", " ", " ", " ", " " },
}

Grid = {}


Wordlength = string.len(Word)

GridMax = 5
GridSize = 20
GridSizeDraw = 19

SelectX, SelectY = 1 ,1 

win = false




function love.load()

    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()


    for i = 1, Wordlength do
        table.insert(WordStorage,
        {
            ichar = string.sub(Word,i,i),
            correct = false
        }
    
    )
    end
    
    for y = 1, GridMax do
        Grid[y] = {}
        for x = 1, GridMax do
            Grid[y][x] = {
                block = ' ',
                flag = 'neutral'
            }            
        end
    end
    font = love.graphics.newFont(18)
end


function love.keypressed(key)    
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'left' then
        SelectX = SelectX - 1

    elseif key == 'right' then
        SelectX = SelectX + 1

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
            win = false
        end


        -- characters

    elseif string.byte(key) > 96 and string.byte(key) < 123 then 
        LaatsteToets = string.byte(key)
        GuessedWord[SelectY][SelectX] = string.char(LaatsteToets) 
        SelectX = SelectX + 1
    end
end

function love.update(dt)

end

function love.draw()

    if win == false then
            
        for y = 1, GridMax do
            for x = 1, GridMax do
                
                if Grid[y][x].flag == 'neutral' then
                    love.graphics.setColor(1,1,1,0.5)

                elseif Grid[y][x].flag == 'possible' then
                    love.graphics.setColor(1,1,0,0.7)
                                
                elseif Grid[y][x].flag == 'correct' then
                    love.graphics.setColor(0,.87,0,0.7)

                end
                
                love.graphics.rectangle('fill',x * GridSize,y * GridSize,GridSizeDraw,GridSizeDraw)                  

            end
        end    

        for y=1 , 5 do
            for x = 1, 5 do
                love.graphics.setColor(1,0,0,1)
                love.graphics.print(tostring(GuessedWord[y][x]), (x * GridSize) + GridSize / 4 , (y * GridSize)) 
            end
        end
        
        love.graphics.setColor(1,1,1,0.3)
        love.graphics.rectangle('fill', (SelectX * GridSize), (SelectY * GridSize), GridSizeDraw, GridSizeDraw )
    else
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf('You Won',(WINDOW_WIDTH / 2) - font:getWidth('You Won'), (WINDOW_HEIGHT / 2)  , 125, "center")
    end




         

end

