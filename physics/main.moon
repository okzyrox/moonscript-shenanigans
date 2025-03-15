world = nil
main_ball = nil
ground = nil
groundShape = nil

class ball
    new: (world) =>
        @img = love.graphics.newImage "assets/love-ball.png"
        @body = love.physics.newBody(world, 400, 300, "dynamic")
        @shape = love.physics.newCircleShape(0, 0, 32)
    
    draw: =>
        love.graphics.draw @img, @body.getX(@body), @body.getY(@body), @body.getAngle(@body), 1, 1, 32, 32
    
    keypressed: (key) =>
        if key == "space"
            @body.applyLinearImpulse @body, 150-math.random(0, 300), -math.random(0, 1500)
    

love.load = ->
    love.graphics.setFont love.graphics.newFont(11)

    love.physics.setMeter 32
    world = love.physics.newWorld(0, 9.81 * 32, true)

    ground = love.physics.newBody(world, 0, 0, "static")
    groundShape = love.physics.newRectangleShape(400, 500, 600, 10)
    groundFixture = love.physics.newFixture(ground, groundShape)

    main_ball = ball(world)

    ball_fixture = love.physics.newFixture(main_ball.body, main_ball.shape)

    main_ball.body.setMassData(main_ball.body, main_ball.shape.computeMass(main_ball.shape, 1))

love.update = (dt) ->
    if world != nil
        world.update(world, dt)

love.draw = ->
    if world != nil and ground != nil and groundShape != nil and main_ball != nil
        love.graphics.polygon "line", ground.getWorldPoints(ground, groundShape.getPoints(groundShape))
        
        main_ball\draw()

love.keypressed = (key) ->
    if main_ball != nil
        main_ball\keypressed(key)
