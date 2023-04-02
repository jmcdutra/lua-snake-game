local screenWidth, screenHeight = guiGetScreenSize()

local points = 0

function addPoint()
    points = points + 1
end

function initSnake()
    points = 0
    snake = {
        {x = 10, y = 10},
        {x = 9, y = 10},
        {x = 8, y = 10},
        {x = 7, y = 10},
        {x = 6, y = 10},
        {x = 5, y = 10},
        {x = 4, y = 10},
        {x = 3, y = 10},
        {x = 2, y = 10},
        {x = 1, y = 10}
    }
    direction = "right"
    spawnApple()
end

function spawnApple()
    apple = {
        x = math.random(0, 79),
        y = math.random(0, 59)
    }
end

function drawSnake()
    for i, segment in ipairs(snake) do
        dxDrawRectangle(segment.x * 10, segment.y * 10, 10, 10)
    end
end

function drawApple()
    dxDrawRectangle(apple.x * 10, apple.y * 10, 10, 10, tocolor(255, 0, 0, 255))
end

function moveSnake()
    local head = snake[1]
    if direction == "right" then
        head = {x = head.x + 1, y = head.y}
    elseif direction == "left" then
        head = {x = head.x - 1, y = head.y}
    elseif direction == "up" then
        head = {x = head.x, y = head.y - 1}
    elseif direction == "down" then
        head = {x = head.x, y = head.y + 1}
    end
    
    if head.x < 0 or head.x > 79 or head.y < 0 or head.y > 59 then
        -- Player colidiu com a parede, resetar game
        initSnake()
        return
    end
    
    for i, segment in ipairs(snake) do
        if i > 1 and head.x == segment.x and head.y == segment.y then
            -- Player colidiu com o própio corpo, resetar game
            initSnake()
            return
        end
    end
    
    if head.x == apple.x and head.y == apple.y then
        table.insert(snake, 1, head)
        spawnApple()
		    addPoint()
    else
        table.insert(snake, 1, head)
        table.remove(snake)
    end
end

function onClientRender()
    dxDrawRectangle(0, 0, 800, 600, tocolor(0, 0, 0, 255))
    drawSnake()
    drawApple()

	dxDrawText("Points: " .. points, 0, 0, 800, 600, tocolor(255, 255, 255), 1.5, "default-bold", "right", "bottom")
end

function onClientKey(key, state)
    if state and (key == "arrow_r" or key == "d") and direction ~= "left" then
        direction = "right"
    elseif state and (key == "arrow_l" or key == "a") and direction ~= "right" then
        direction = "left"
    elseif state and (key == "arrow_u" or key == "w") and direction ~= "down" then
        direction = "up"
    elseif state and (key == "arrow_d" or key == "s") and direction ~= "up" then
    	direction = "down"
	end
end


addEventHandler("onClientResourceStart", resourceRoot, function()
	initSnake()
	addEventHandler("onClientRender", root, onClientRender)
	addEventHandler("onClientKey", root, onClientKey)
	setTimer(moveSnake, 100, 0)
	--setFPSLimit(30)
end)
