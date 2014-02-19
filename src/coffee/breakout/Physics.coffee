class Physics
    'use strict'

    constructor: (@options) ->
        @ball = @options.ball
        @pad = @options.pad
        @bricks = @options.bricks
        @onFail = @options.onFail
        @onHitBrick = @options.onHitBrick
        @onHitBonus = @options.onHitBonus
        @onHitPad = @options.onHitPad
        @lastT = undefined
        @bonuses = []

    tick: (t) ->
        if @lastT?
            dt = t - @lastT

            #update pad speed
            if @pad.lastX != @pad.x
                @pad.dx = (@pad.x - @pad.lastX) / dt
                @pad.lastX = @pad.x
            else
                @pad.dx = 0

            # because of not bulletproof collision algorithm
            ballSpeed = Math.max(Math.abs(@ball.dx), Math.abs(@ball.dy))
            safeDistance = @ball.r *.9

            if ballSpeed * dt > safeDistance
                safeGap = safeDistance / ballSpeed
                safeT = @lastT + safeGap
                safeLastT = @lastT
                cnt = 1
                while safeT < t
                    @emulate(safeT - safeLastT)
                    safeLastT = safeT
                    safeT += safeGap
                    cnt += 1

                @emulate(t - safeLastT)
            else
                @emulate(dt)
        @lastT = t

    emulate: (dt) ->
        
        # move ball
        ball = @ball
        ball.x += ball.dx * dt
        ball.y += ball.dy * dt
        
        # ball|walls collision
        if ball.y1() > 1
            @onFail()
        if ball.y0() < 0
            ball.y -= ball.dy * dt
            ball.dy = -ball.dy
        if ball.x0() < 0
            ball.x -= ball.dx * dt
            ball.dx = -ball.dx
        if ball.x1() > 1
            ball.x -= ball.dx * dt
            ball.dx = -ball.dx

        # ball|paddle collision
        pad = @pad
        if @canIntersect(ball, pad)
            if @pad.x0() <= ball.x && @pad.x1() >= ball.x
                if @pad.y0() <= ball.y1() && @pad.y0() >= ball.y
                    ball.y -= ball.dy * dt
                    @inverseDY(ball)
                    ball.dx += @pad.dx / 4
                    @onHitPad()

        # ball|bricks
        hittedBricks = []
        
        i = 0
        while i < @bricks.length
            brick = @bricks[i]
            if @canIntersect(ball, brick)
                # bottom->top collision
                if ball.dy < 0 && ball.y > brick.y1() && ball.y0() <= brick.y1()
                    if (ball.x1() >= brick.x0() && ball.x1() <= brick.x1()) || (ball.x0() >= brick.x0() && ball.x0() <= brick.x1())
                        ball.y -= ball.dy * dt
                        @inverseDY(ball)
                        hittedBricks.push(brick)

                # top->bottom collision
                if ball.dy > 0 && ball.y < brick.y0() && ball.y1() >= brick.y0()
                    if (ball.x1() >= brick.x0() && ball.x1() <= brick.x1()) || (ball.x0() >= brick.x0() && ball.x0() <= brick.x1())
                        ball.y -= ball.dy * dt
                        @inverseDY(ball)
                        hittedBricks.push(brick)

                # left->right collision
                if ball.dx > 0 && ball.x < brick.x0() && ball.x1() >= brick.x0()
                    if (ball.y1() >= brick.y0() && ball.y1() <= brick.y1()) || (ball.y0() >= brick.y0() && ball.y0() <= brick.y1())
                        ball.x -= ball.dx * dt
                        @inverseDX(ball)
                        hittedBricks.push(brick)

                # right->left collision
                if ball.dx < 0 && ball.x > brick.x1() && ball.x0() <= brick.x1()
                    if (ball.y1() >= brick.y0() && ball.y1() <= brick.y1()) || (ball.y0() >= brick.y0() && ball.y0() <= brick.y1())
                        ball.x -= ball.dx * dt
                        @inverseDX(ball)
                        hittedBricks.push(brick)
            i++;

        i = 0
        while i < hittedBricks.length
            @onHitBrick(hittedBricks[i])
            i++;

        # move bonus
        i = 0
        while i < @bonuses.length
            bonus = @bonuses[i]
            bonus.y += bonus.dy * dt
            # out of bounds
            if bonus.y > 1
                bonus.out = true
            # bonus|paddle collision
            else if @canIntersect(bonus, pad)
                if @pad.x0() <= bonus.x && @pad.x1() >= bonus.x
                    if @pad.y0() <= bonus.y1() && @pad.y0() >= bonus.y
                        bonus.out = true
                        @onHitBonus(bonus)
            i++

        # remove disabled @bonuses
        i = 0
        while i < @bonuses.length
            bonus = @bonuses[i]
            if bonus.out
                @bonuses.splice(i, 1)
            i++

    canIntersect: (chip, dale) ->
        Math.abs(chip.x - dale.x) <= chip.w05 + dale.w05 && Math.abs(chip.y - dale.y) <= chip.h05 + dale.h05

    inverseDY: (ball) ->
        ball.dx += (Math.random() * .000002) - .000004
        ball.dy = -ball.dy
        ball

    inverseDX: (ball) ->
        ball.dy += (Math.random() * .000002) - .000004
        ball.dx = -ball.dx
        ball
