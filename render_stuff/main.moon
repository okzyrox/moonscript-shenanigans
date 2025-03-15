
max_zindex = 32

tablefind = (t, el) ->
    for i, v in ipairs(t)
        if v == el
            return i
    return nil

round = (x) ->
    if x >= 0
        return math.floor(x + 0.5)
    else
        return math.ceil(x - 0.5)

class RenderManager
    new: =>
        @items = {} -- {zindex: {item, item, item}}
        @min_zindex = 0
    
    add: (item, zindex) =>
        if zindex > max_zindex
            zindex = max_zindex
        if @items[zindex] == nil
            @items[zindex] = {}
        table.insert(@items[zindex], item)
        @min_zindex = math.min(@min_zindex, zindex)
        
    remove: (item, zindex) =>
        if @items[zindex] != nil
            if tablefind(@items[zindex], item) != nil
                table.remove(@items[zindex], tablefind(@items[zindex], item))
                if #(@items[zindex]) == 0
                    @items[zindex] = nil
                    if zindex == @min_zindex
                        @min_zindex = math.huge
                        for k, v in pairs(@items)
                            @min_zindex = math.min(@min_zindex, k)
    
    set_zindex: (item, zindex) =>
        @remove(item)
        @add(item, zindex)
    
    draw: =>
        for i = @min_zindex, max_zindex
            if @items[i] != nil
                for _, item in ipairs(@items[i])
                    item\draw()


class item
    new: (x, y, zindex, color) =>
        color[4] = 0.5
        @x = x
        @y = y
        @color = color or {255, 255, 255}
        @zindex = zindex
    
    draw: =>
        love.graphics.setColor @color
        love.graphics.circle "fill", @x, @y, 64, 64
        love.graphics.setColor {255, 255, 255}

render_manager = RenderManager()

love.load = ->
    render_manager\add(item(100, 100, 1, {255, 0, 0}), 0)
    render_manager\add(item(150, 175, 2, {0, 255, 0}), 2)
    render_manager\add(item(200, 225, 3, {0, 0, 255}), 3)
    render_manager\add(item(250, 275, 4, {255, 255, 0}), 4)
    render_manager\add(item(300, 325, 5, {255, 0, 255}), 3)
    render_manager\add(item(350, 375, 6, {0, 255, 255}), 2)
    render_manager\add(item(400, 425, 7, {255, 255, 255}), 1)

love.draw = ->
    love.graphics.print "FPS: " .. tostring(love.timer.getFPS()), 10, 10
    love.graphics.print "Mem: " .. tostring(round(collectgarbage("count"))/1000) .. " MB", 10, 30
    render_manager\draw()

love.keypressed = (key) ->
    if key == "escape"
        love.event.quit()