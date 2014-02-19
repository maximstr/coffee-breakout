class Game

    constructor: (@options) ->
        @canvas = @options.canvas
        @render = new @options.renderClass(@options)
        @level = 0
        @lifes = 3

    start: ->
        @gameOn = true
        @pad = new Paddle(.5, .95, .15, .01)
        @ball = new Ball(@pad.x, .9, .01, .0, -.0004)
        @physics = new Physics(
            ball: @ball,
            pad: @pad,
            onFail: $.proxy(@onFail, this),
            onHitBrick: $.proxy(@onHitBrick, this),
            onHitBonus: $.proxy(@onHitBonus, this),
            onHitPad: $.proxy(@onHitPad, this)
        )
        @startNextLevel()
        @resize()
        @animate()
        $(@canvas.parentNode).bind("mousemove touchmove", $.proxy(@touchMove, this))

    stop: ->
        $(@canvas.parentNode).unbind("mousemove touchmove")
        @gameOn = false
        @options.onComplete(this)

    startNextLevel: ->
        @bricks = new PlaygroundBuilder().getBrickFormation(@level)
        @hitsToNextLevel = 0
        i = 0
        while i < @bricks.length
            hits = @bricks[i].hits
            @hitsToNextLevel += if hits < 3 then hits else 0
            i++
        @ball.x = @pad.x
        @ball.y = .9
        @ball.dx = (Math.random() * .0002) - .0004
        @ball.dy = -(.0004 + @level*.00005)
        @physics.bricks = @bricks

    onFail: ->
        @ball.x = @pad.x
        @ball.y = .9
        @ball.dx = (Math.random() * .0002) - .0004
        @ball.dy = -(.0004 + @level*.00005)
        @lifes -= 1
        if @lifes <= 0 
            alert("Game over!")
            @stop()
        
    onHitPad: ->
        # speedup ball
        @ball.dy *= 1.005

    onHitBonus: (bonus) -> 
        switch bonus.id
            when 0
                @pad.w += .05
                if @pad.w > .5
                    @pad.w = .5
                
                @pad.w05 = @pad.w / 2
            # smaller pad
            when 1
                @pad.w -= .05
                if @pad.w < .05
                    @pad.w = .05
                
                @pad.w05 = @pad.w / 2
            # ball faster
            when 2
                @ball.dy *= 1.5
                @ball.dx *= 1.5
            # ball slower
            when 3
                #break
                @ball.dy *= .75
                @ball.dx *= .75
            else
                throw new Error('unknown bonus id')

    onHitBrick: (brick) ->  
        # speedup ball
        @ball.dy *= 1.0005
        if brick.hits < 3
            @hitsToNextLevel -= 1
            brick.hits -= 1
            if brick.hits <= 0
                # remove the brick
                i = 0
                while i < @bricks.length
                    if @bricks[i] == brick
                        @bricks.splice(i, 1)
                    i++
            
            if Math.random() <= .05
                # drop bonus
                bonus = new Bonus(brick.x, brick.y, ~~(Math.random() * 4), .0005 + @level*.0001)
                @physics.bonuses.push(bonus)

        # level complete
        if @hitsToNextLevel <= 0
            if @level < 2
                @level += 1
                @startNextLevel()
            else 
                alert("You win!")
                @stop()

    touchMove: (e) ->
        e.preventDefault()
        if !@gameOn 
            return
        
        px = e.pageX
        if !px
            touches = e.touches ||  window.event.touches
            if !touches
                return
            
            px = touches[0].pageX
        
        px -= @canvasX
        if px < 0
            px = 0
        
        if px > @canvasWidth
            px = @canvasWidth
        
        @pad.x = px / @canvasWidth

    renderAll: ->
        @render.startRender()
        @render.drawBall(@ball)
        @render.drawPaddle(@pad)
        @render.drawBricks(@bricks)
        if @physics.bonuses && @physics.bonuses.length
            @render.drawBonuses(@physics.bonuses)
        
        @render.stopRender()

    resize: ->
        @canvasX = @canvas.offsetLeft
        @canvasWidth = @canvas.width
        @render.resize()
        @renderAll()

    animate: ->
        if @gameOn 
            @physics.tick(new Date().getTime())
            @renderAll()
            requestAnimFrame($.proxy(@animate, this))
