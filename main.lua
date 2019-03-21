local function DetectionKeyClick()
    --按键检测
    if(love.keyboard.isDown("up")) then
        qy=qy-5
    end
    if(love.keyboard.isDown("down")) then
        qy=qy+5
    end
    if(love.keyboard.isDown("left")) then
        qx=qx-5
    end
    if(love.keyboard.isDown("right")) then
        qx=qx+5
    end
end

function love.load()
    love.window.setMode(600, 750)
    music = love.audio.newSource("BG.mp3", "stream")
    love.audio.play(music)
    BgImage = love.graphics.newImage("bg.jpg")
    BgTransform = love.math.newTransform(0, 0, 0, 0.8, 0.8, 580, 80)
end

function love.update(dt)
    local musicNum = love.audio.getActiveSourceCount()
    if musicNum == 0 then
        love.audio.play(music)
    end
    --print(musicNum)
    DetectionKeyClick()

end

function love.draw()
    love.graphics.draw(BgImage, BgTransform)
    love.graphics.print("Click and drag the cake around or use the arrow keys", 10, 10)
end


    