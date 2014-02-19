class CanvasRenderer

    constructor: (@args) ->
        @canvas = @args.canvas
        @skin = @args.skin
        @ctx = @canvas.getContext("2d")
        @width = 0
        @height = 0
        @resize()

    resize: ->
        @width = @canvas.width
        @height = @canvas.height

    # percent[0..1] to canvas coordinates [0..canvas.width]
    p2x: (percent) ->
        percent * @width

    # rendering
    startRender: ->
        @ctx.clearRect(0, 0, @width, @height)

    stopRender: ->

    drawBall: (ball) ->
        @ctx.save()
        @ctx.beginPath()
        @ctx.fillStyle = if @skin then "rgb(0, 0, 0)" else "rgb(255, 255, 255)"
        @ctx.arc(@p2x(ball.x), @p2x(ball.y), @p2x(ball.r), 0, 2 * Math.PI)
        @ctx.closePath()
        @ctx.fill()
        @ctx.restore()

    drawBonuses: (bonuses) ->
        @ctx.save()
        i = 0
        while i < bonuses.length
            bonus = bonuses[i]
            @ctx.fillStyle = "rgb(33, 0, 0)"
            switch bonus.id
                when 0
                    @ctx.fillStyle = if @skin then "rgb(0, 200, 0)" else "rgb(200, 255, 200)"
                when 1
                    @ctx.fillStyle = if @skin then "rgb(200, 0, 0)" else "rgb(255, 200, 200)"
                when 2
                    @ctx.fillStyle = if @skin then "rgb(33, 33, 0)" else "rgb(255, 255, 200)"
                when 3
                    @ctx.fillStyle = if @skin then "rgb(0, 33, 33)" else "rgb(200, 255, 255)"
                else
                    throw new Error("unknown bonus type")
            @ctx.fillRect(@p2x(bonus.x0()), @p2x(bonus.y0()), @p2x(bonus.w), @p2x(bonus.h))
            i++
        
        @ctx.restore()

    drawBricks: (bricks) ->
        sortBricks = [[], [], []]

        i = 0
        while i < bricks.length
            b = bricks[i]
            sortBricks[if b.hits > 2 then 2 else b.hits - 1].push(b)
            i++
        
        # 1 hit bricks
        @ctx.save()
        sameBricks = sortBricks[0]
        @ctx.fillStyle = if @skin then "rgb(0, 0, 0)" else "rgb(255, 255, 255)"

        i = 0
        while i < sameBricks.length
            b = sameBricks[i]
            @ctx.fillRect(@p2x(b.x0()), @p2x(b.y0()), @p2x(b.w), @p2x(b.h))
            i++
        
        @ctx.restore()

        # 2 hit bricks
        @ctx.save()
        sameBricks = sortBricks[1]
        @ctx.fillStyle = if @skin then "rgb(128, 128, 128)" else "rgb(128, 128, 128)"

        i = 0
        while i < sameBricks.length
            b = sameBricks[i]
            @ctx.fillRect(@p2x(b.x0()), @p2x(b.y0()), @p2x(b.w), @p2x(b.h))
            i++
        
        @ctx.restore()

        # n hit bricks
        @ctx.save()
        sameBricks = sortBricks[2]
        @ctx.fillStyle = if @skin then "rgb(200, 200, 200)" else "rgb(32, 32, 32)"

        i = 0
        while i < sameBricks.length
            b = sameBricks[i]
            @ctx.fillRect(@p2x(b.x0()), @p2x(b.y0()), @p2x(b.w), @p2x(b.h))
            i++
        
        @ctx.restore()

    drawPaddle: (paddle) ->
        @ctx.save()
        @ctx.fillStyle = if @skin then "rgb(0, 0, 0)" else "rgb(255, 255, 255)"
        @ctx.fillRect(@p2x(paddle.x0()), @p2x(paddle.y0()), @p2x(paddle.w), @p2x(paddle.h))
        @ctx.restore()
