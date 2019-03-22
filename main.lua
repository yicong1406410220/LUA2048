local function swap(a, b)
    return b, a
end

local function DoTableMove(a, b, c, d)
    local testTable = {a, b, c, d}   
    for h = 1, 3 do
        --是否需要搬运数字
        local isCarry = false
        if testTable[h] == 0 then
            isCarry = true
        end 
        for g = h + 1, 4 do
            if testTable[g] ~= 0 and isCarry then
                testTable[h], testTable[g] = swap(testTable[h], testTable[g])
                isCarry = false
            elseif isCarry == false and testTable[g] ~= 0 then
                if testTable[g] == testTable[h] then 
                    testTable[h] = testTable[g] + testTable[h]
                    testTable[g] = 0
                    GameScore = GameScore + testTable[h] 
                end
                break
            end 
        end 
    end 
    print(table.concat(testTable, ","))
    return testTable[1], testTable[2], testTable[3], testTable[4]
end

local function DetectionKeyClick()
    --按键检测
    if(love.keyboard.isDown("up")) then
        for i = 1, 4 do
            GameArray[i][1], GameArray[i][2], GameArray[i][3], GameArray[i][4] = DoTableMove(GameArray[i][1], GameArray[i][2], GameArray[i][3], GameArray[i][4])         
        end
    end
    if(love.keyboard.isDown("down")) then
        for i = 1, 4 do
            GameArray[i][4], GameArray[i][3], GameArray[i][2], GameArray[i][1] = DoTableMove(GameArray[i][4], GameArray[i][3], GameArray[i][2], GameArray[i][1])         
        end
    end
    if(love.keyboard.isDown("left")) then
        for j = 1, 4 do
            GameArray[1][j], GameArray[2][j], GameArray[3][j], GameArray[4][j] = DoTableMove(GameArray[1][j], GameArray[2][j], GameArray[3][j], GameArray[4][j])         
        end
    end
    if(love.keyboard.isDown("right")) then
        for j = 1, 4 do
            GameArray[4][j], GameArray[3][j], GameArray[2][j], GameArray[1][j] = DoTableMove(GameArray[4][j], GameArray[3][j], GameArray[2][j], GameArray[1][j])         
        end
    end
end


isLose = false
GameScore = 0
GameHighScore = 0
GameArray = {}
TableCache = {}

function love.load()
    love.window.setMode(600, 750)
    music = love.audio.newSource("BG.mp3", "stream")
    love.audio.play(music)
    BgImage = love.graphics.newImage("bg.jpg")
    BgTransform = love.math.newTransform(0, 0, 0, 0.8, 0.8, 580, 80)
    LoseImage = love.graphics.newImage("lose.png")
    LoseTransform = love.math.newTransform(0, 0, 0, 0.8, 0.8, 580, 80)
    SquareImage = love.graphics.newImage("kpbg.png")
    InitGame()
end

function love.update(dt)
    local musicNum = love.audio.getActiveSourceCount()
    if musicNum == 0 then
        love.audio.play(music)
    end
    --print(musicNum)
end

function love.draw()
    love.graphics.draw(BgImage, BgTransform)
    --打印当前积分
    love.graphics.print(GameScore, 190, 50, 0, 2, 2)
    --打印最高分数
    love.graphics.print(GameHighScore, 402, 50, 0, 2, 2)
    UpdateGameScreen()
    if isLose then
        love.graphics.draw(LoseImage, LoseTransform)
    end
end

function love.keyreleased(key)
    if isLose then
        return
    end
    for i = 1, 4 do
        for j = 1, 4 do
            TableCache[i][j] = GameArray[i][j]
        end
    end
    if(key =="up") then
        for i = 1, 4 do
            GameArray[i][1], GameArray[i][2], GameArray[i][3], GameArray[i][4] = DoTableMove(GameArray[i][1], GameArray[i][2], GameArray[i][3], GameArray[i][4])         
        end
    end
    if(key =="down") then
        for i = 1, 4 do
            GameArray[i][4], GameArray[i][3], GameArray[i][2], GameArray[i][1] = DoTableMove(GameArray[i][4], GameArray[i][3], GameArray[i][2], GameArray[i][1])         
        end
    end
    if(key =="left") then
        for j = 1, 4 do
            GameArray[1][j], GameArray[2][j], GameArray[3][j], GameArray[4][j] = DoTableMove(GameArray[1][j], GameArray[2][j], GameArray[3][j], GameArray[4][j])         
        end
    end
    if(key =="right") then
        for j = 1, 4 do
            GameArray[4][j], GameArray[3][j], GameArray[2][j], GameArray[1][j] = DoTableMove(GameArray[4][j], GameArray[3][j], GameArray[2][j], GameArray[1][j])         
        end
    end
    for i = 1, 4 do
        for j = 1, 4 do
            if TableCache[i][j] ~= GameArray[i][j] then
                RandomSetSquare2()
                isLose = detectIsLose()
                return
            end
        end
    end
end

function love.mousereleased(x, y, button, istouch)
    if button == 1 then
       fireSlingshot(x,y) -- this totally awesome custom function is defined elsewhere
    end
end

function fireSlingshot(x,y) 
    if x > 430 and x < 530 and y > 630 and y < 670 then
        InitGame()
    end
end

--检测玩家是否输了
function detectIsLose()
    for x = 1, 4 do
        for y = 1, 4 do
            local fx = x - 1
            local fy = y
            if fx >= 1 and fx <= 4 and fy >= 1 and fy <= 4 then
                if GameArray[fx][fy] == 0 or GameArray[x][y] == GameArray[fx][fy] then
                    return false
                end
            end 
            fx = x + 1
            fy = y
            if fx >= 1 and fx <= 4 and fy >= 1 and fy <= 4 then
                if GameArray[fx][fy] == 0 or GameArray[x][y] == GameArray[fx][fy] then
                    return false
                end
            end 
            fx = x
            fy = y - 1
            if fx >= 1 and fx <= 4 and fy >= 1 and fy <= 4 then
                if GameArray[fx][fy] == 0 or GameArray[x][y] == GameArray[fx][fy] then
                    return false
                end
            end 
            fx = x
            fy = y + 1
            if fx >= 1 and fx <= 4 and fy >= 1 and fy <= 4 then
                if GameArray[fx][fy] == 0 or GameArray[x][y] == GameArray[fx][fy] then
                    return false
                end
            end 
        end
    end
    return true
end 

--创建数字方块
function CreaterSquare(arrayX, arrayY, num)
    local fromX = 75
    local formY = 130
    local x = fromX + (arrayX - 1) * 120
    local y = formY + (arrayY - 1) * 120
    local SquareTransform = love.math.newTransform(x, y, 0, 0.8, 0.8, 0, 0)
    love.graphics.draw(SquareImage, SquareTransform)
    assert(type(num) == "number", "num 不是一个数字")
    local numberStr = tostring(num)
    local numberlen = string.len(numberStr)
    love.graphics.print(numberStr, x + 45 - ((numberlen - 1) * 10), y + 35, 0, 2.4, 2.4)
end
--初始化游戏
function InitGame()
    isLose = false
    GameScore = 0
    math.randomseed(os.time())
    --print(os.time())
    for i = 1, 4 do
        local son = {}
        GameArray[i] = son
        for j = 1, 4 do
            son[j] = 0
        end
    end

    for i = 1, 4 do
        local son = {}
        TableCache[i] = son
        for j = 1, 4 do
            son[j] = 0
        end
    end
    
    RandomSetSquare2()
    RandomSetSquare2()
end

--随机生成1个2号方块
function RandomSetSquare2()
    local numRandX
    local numRandY 
    repeat
        numRandX = math.random(4)
        numRandY = math.random(4)
    until GameArray[numRandX][numRandY] == 0
    GameArray[numRandX][numRandY] = 2
end

--在视图里显示数组
function UpdateGameScreen()
    for i = 1,  #GameArray do
        for j = 1, #GameArray[i] do
            if GameArray[i][j] ~= 0 then
                CreaterSquare(i, j, GameArray[i][j])
            end         
        end
    end
end

