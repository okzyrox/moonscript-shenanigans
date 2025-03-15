class player
    new: (x, y) =>
        @x = x or 0 
        @y = y or 0
    
    draw: =>
        love.graphics.rectangle "fill", @x, @y, 64, 64
    
    input: =>
        if love.keyboard.isDown "up"
            @y -= 1
        if love.keyboard.isDown "down"
            @y += 1
        if love.keyboard.isDown "left"
            @x -= 1
        if love.keyboard.isDown "right"
            @x += 1
    
    update: =>
        @input()

class ui
    new: =>
        @x = 0
        @y = 0
    
    draw: =>
        love.graphics.print "FPS: " .. tostring love.timer.getFPS(), @x + 10, @y + 10

-- init

plr = player(100, 100)
ui = ui()

love.load = ->
    love.window.setTitle "MoonScript stuffs"
    love.window.setMode 800, 600

love.draw = ->
    plr\draw()
    ui\draw()

love.update = ->
    plr\input()