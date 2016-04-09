# Import file "CodeMakers"
sketch = Framer.Importer.load("imported/CodeMakers@1x")

######## SETUP ########
sketch.progressBar1.visible = no
sketch.contentControls.visible = yes
sketch.overlay.visible = no
sketch.slideCount.visible = no


######## GLOBAL VARIABLES ########
currentSlideNumber = 1
totalNumberOfSlides = 16

#################################################################################
###########################   LESSON CONTENT   ##################################
#################################################################################

# Setup lesson content with the correct slide
changeSlide = (slideNumber)->
	sketch.lessonContent.image = "images/dash-images/#{slideNumber}.jpg"
	print "You are on slide #{currentSlideNumber}"
	sketch.tick.visible = false
	sketch.skipButton.visible = false
	sketch.getHelpButton.visible = false
	if currentSlideNumber is 12
		sketch.skipButton.visible = true
		sketch.getHelpButton.visible = true
	
############# CHECKPOINTS #################
sketch.codeEditor.onClick ->
	if currentSlideNumber is 12
		tickOffCheckpoint()

tickOffCheckpoint = ->
	sketch.tick.visible = true
	sketch.tick.x = 20
	sketch.tick.sendToBack()
	
	scaleUp = new Animation
		layer: sketch.tick
		properties: 
			scale: 2
			time: 0.3
	scaleDown = new Animation 
		layer: sketch.tick
		properties: 
			scale: 1
			opacity: 1
			time: 0.3
	scaleUp.on(Events.AnimationEnd, scaleDown.start)
	scaleUp.start()

#################################################################################
###########################   PROGRESS BAR   ####################################
#################################################################################

progressBarFiller = new Layer
	parent: sketch.progressBar
	height: sketch.progressBar.height
	width: currentSlideNumber / totalNumberOfSlides * sketch.header.width

progressBarFiller.style =
	"background": "-webkit-gradient(linear, left top, left bottom, color-stop(0%,#FAD961), color-stop(100%,#D5A700))"
	"border-top-right-radius" : "6px"
	"border-bottom-right-radius" : "6px"

updateProgressBar = ->
	progressAnimation = new Animation
		layer: progressBarFiller
		properties: 
			width: currentSlideNumber / totalNumberOfSlides * sketch.header.width
			time: 0.3
	progressAnimation.start()

#### Content Quick Jump ####
thumbnail = new Layer
	width: 200
	height: 100
	image: "images/dash-images/#{currentSlideNumber}.jpg"
	borderRadius: 10
	borderColor: "#333333"
	shadowX: 3
	shadowY: 3
	shadowBlur: 10
	borderWidth: 1
	visible: false

sketch.progressBar.on Events.MouseMove, (event, layer) ->
	thumbnail.visible = true
	thumbnail.x = event.clientX
	thumbnail.y = sketch.progressBar.y - thumbnail.height - 10
	
	position = event.clientX / sketch.progressBar.width * 16
	number = Math.round(position)
	thumbnail.image = "images/dash-images/#{number}.jpg"

sketch.progressBar.onMouseOut ->
	thumbnail.visible = false

sketch.progressBar.on Events.Click, (event, layer) ->
	position = event.clientX / sketch.progressBar.width * 16
	number = Math.round(position)
	currentSlideNumber = number
	changeSlide(number)
	updateProgressBar()
	

#################################################################################
###########################   CONTENT CONTROLS   ################################
#################################################################################
fadeTime = 0.2

# Create content controls overlay
contentControlsOverlay = new Layer
		parent: sketch.contentControls
		name: "overlay"
		backgroundColor: "#000000"
		width: sketch.lessonContent.width
		height: sketch.lessonContent.height
		opacity: 0
contentControlsOverlay.sendToBack()

# Reposition next and previous buttons
sketch.previousButton.x = - sketch.previousButton.width
sketch.nextButton.x = sketch.lessonContent.maxX

# Fade in overlay
fadeInOverlay = new Animation
	layer: contentControlsOverlay
	properties: 
		opacity: 0.3
		time: fadeTime
	
# Display Previous Button
showPrevButton = new Animation
	layer: sketch.previousButton
	properties: 
		x: 0
		time: fadeTime

# Display Next Button
showNextButton = new Animation
	layer: sketch.nextButton
	properties: 
		x: sketch.lessonContent.maxX - sketch.nextButton.width + 10
		time: fadeTime

###########################   HOVER OVER LESSON CONTENT   #######################
displayButtons = -> 
	if currentSlideNumber > 1 
		showPrevButton.start()
	if currentSlideNumber < totalNumberOfSlides
		showNextButton.start()

removeButtons = ->
	if currentSlideNumber <= 1
		showPrevButton.reverse().start()
	if currentSlideNumber >= totalNumberOfSlides
		showNextButton.reverse().start()

sketch.lessonContent.onMouseOver ->
	fadeInOverlay.start()
	displayButtons()

sketch.lessonContent.onMouseOut ->
	fadeInOverlay.reverse().start()
	showPrevButton.reverse().start()
	showNextButton.reverse().start()

###########################   CHANGE TO NEXT SLIDES   #######################
nextSlide = ->
	currentSlideNumber = currentSlideNumber - 1
	changeSlide(currentSlideNumber)
	updateProgressBar()
	displayButtons()
	removeButtons()
	
previousSlide = ->
	currentSlideNumber = currentSlideNumber + 1
	changeSlide(currentSlideNumber)
	updateProgressBar()
	displayButtons()
	removeButtons()

sketch.previousButton.onClick ->
	nextSlide()

sketch.nextButton.onClick ->
	previousSlide()
	

#################################################################################
###########################   INIT   ############################################
#################################################################################
changeSlide(currentSlideNumber)
updateProgressBar()


