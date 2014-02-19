
class Ball
	constructor: (@x, @y, @r, @dx, @dy) ->
		@w = @r * 2
		@h = @r * 2
		@w05 = @r
		@h05 = @r

	move: (dt) ->
		@x += @dx * dt
		@y += @dy * dt

	x0: ->
		@x - @r
	y0: ->
		@y - @r
	x1: ->
		@x + @r
	y1: ->
		@y + @r

class RectObject
	constructor: (@x, @y, @w, @h) ->
		@w05 = @w * .5
		@h05 = @h * .5

	x0: ->
		@x - @w05
	y0: ->
		@y - @h05
	x1: ->
		@x + @w05
	y1: ->
		@y + @h05

class Paddle extends RectObject
	constructor: (x, y, w, h) ->
		super(x, y, w, h)
		@lastX = x
		@dx = 0

class Brick extends RectObject
	constructor: (x, y, @hits) ->
		super(x, y, .095, .03)
		@id = _.uniqueId()
		# durability
		@hits = hits;

class Bonus extends RectObject
	constructor: (x, y, @id, @dy) ->
		super(x, y, .03, .03)
		@out = false
