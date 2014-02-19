class PlaygroundBuilder
	'use strict';

	getBrickFormation: (level) ->

		getBrick = (i) -> 
			r = do Math.random
			x = (i % 8) * .1 + .15
			y = ~~(i / 8) * .035 + .15
			hits = if r < level / 10 then 3 else (if r < .5 then 1 else 2)
			new Brick(x, y, hits)
			
		brickCount = 32 + level * 32 - 1
		bricks = (getBrick(i) for i in [0..brickCount])

	getTestBrickFormation: (level) ->
		switch level
			when 0 then [new Brick(.5, .5, 1), new Brick(.6, .5, 1), new Brick(.7, .5, 2)]
			when 1 then [new Brick(.5, .5, 1), new Brick(.6, .5, 2), new Brick(.7, .5, 3)]
			when 2 then [new Brick(.5, .5, 2), new Brick(.6, .5, 3), new Brick(.7, .5, 3)]
			else throw new Error("getTestBrickFormation type error")
