Woord = "prima"
WoordOpslag = {}
GeradenWoord = { "x", " ", " ", " ", " " }
Grid = {}

WoordLengte = string.len(Woord)
WoordSub = string.sub(Woord,1,1)

GridMax = 5
GridSize = 20
GridSizeDraw = 19

SelectX = 1
SelectY = 1



function love.load()
    for i = 1, WoordLengte do
        WoordOpslag[i] = string.sub(Woord,i,i)
    end
    
    for y = 1, GridMax do
        Grid[y] = {}
        for x = 1, GridMax do
            Grid[y][x] = ' '
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
    elseif string.byte(key) > 96 and string.byte(key) < 123 then 
        LaatsteToets = string.byte(key)
    end
end

function love.update(dt)

    if LaatsteToets then

        GeradenWoord[SelectX] = string.char(LaatsteToets) 
    end
    
    LaatsteToets = nil
end

function love.draw()
    for y = 1, GridMax do
        for x = 1, GridMax do
            love.graphics.setColor(1,1,1,0.5)
            love.graphics.rectangle('fill',x * GridSize,y * GridSize,GridSizeDraw,GridSizeDraw)  
        end
    end    
    -- for y = 1, 1 do
    --     for x = 1, GridMax do
    --         love.graphics.print(WoordOpslag[x], (x * GridSize)  + (GridSize / 3), y * GridSize) 
    --     end
    -- end    
    for y=1 , 1 do
        for x = 1, #GeradenWoord do
            love.graphics.setColor(1,0,0,1)
            love.graphics.print(tostring(GeradenWoord[x]), (x * GridSize), (y * GridSize)) 
        end
    end

    love.graphics.setColor(1,1,1,0.3)
    love.graphics.rectangle('fill', (SelectX * GridSize), (SelectY * GridSize), GridSizeDraw, GridSizeDraw )
end




