
class Bejeweled
	'use strict'

	constructor: ->
		# views
		@startupPage = $('#startup')
		@gamePage = $('#game')
		@playBtn = @startupPage.find('#play')
		@skinBtn = @startupPage.find('#skin')
		@canvas = @gamePage.find('canvas').eq(0)

		@skinId = 0
		@game = null

		@skinBtn.bind('click', $.proxy(@toggleSkin, @))

		@onResize()
		@showStartupPage()
		
		# bind resize
		window.onresize = $.proxy(@onResize, @)

	showStartupPage: ->
		@playBtn.on('click', $.proxy(@startGame, @))
		@gamePage.hide()
		@startupPage.show()

	showGamePage: ->
		@gamePage.show()
		@startupPage.hide()

	startGame: ->
		@playBtn.unbind('click')
		@showGamePage()
		@game = new Game({
			renderClass: CanvasRenderer,
			onComplete: $.proxy(@stopGame, @),
			canvas: @canvas.get(0),
			skin: @skinId
		})

		@game.start()

	stopGame: ->
		@game = null
		@showStartupPage()

	# resize & orientation
	onResize: ->
		isVertical = window.innerWidth < window.innerHeight
		canvasSize = Math.min(window.innerWidth, window.innerHeight)
		tmpW = canvasSize - canvasSize * .05
		canvas = @canvas.get(0)
		canvas.width = canvas.height = canvasSize - canvasSize * .05;
		@canvas.css('marginLeft', -(tmpW * .5) + 'px')
		@canvas.css('marginTop', -(tmpW * .5) + 'px')

		if @game
			@game.resize(@canvas.width)
		@

	toggleSkin: ->
		$(document.body).removeClass('skin-light skin-dark')
		if @skinId == 0
			$(document.body).addClass('skin-light')
			@skinId = 1
		else
			@skinId = 0
			$(document.body).addClass('skin-dark')

new Bejeweled()
