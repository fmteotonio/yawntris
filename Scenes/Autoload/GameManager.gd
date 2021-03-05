extends Node

#EVENTCODES
#		0:board.removeRandomPiece()
#		1:board.disappearMovingPiece()
#		2:board.forceQueueTimes4()
#		3:board.forceQueuePenta()
#		4:board.forceQueueMega()
#		5:board.forceHardDrop()
#		6:board.hideNext()
#		7:board.hideAll()
#		8:board.flipCameraX()
#		9:board.flipCameraY()
#		10:board.allBecomePentas()
#		
onready var eventList=[
	[ [0],    [2],[3],        [6]                                          ], #LEVEL 0
	[ [0],    [2],[3],        [6],    [8],[9]                              ], #LEVEL 1
	[ [0],    [2],[3],        [6],    [8],[9]                              ], #LEVEL 2
	[ [0],    [2],[3],        [6],    [8],[9],                 [3,2]       ], #LEVEL 3
	[ [0],    [2],[3],            [7],[8],[9],                 [3,2]       ], #LEVEL 4
	[         [2],[3],            [7],             [0,0],[8,9],[3,2]       ], #LEVEL 5
	[         [2],[3],[4],[5],    [7],             [0,0],[8,9],[3,2]       ], #LEVEL 6
	[         [2],    [4],[5],    [7],        [10],[0,0],[8,9],[3,2]       ], #LEVEL 7
	[         [2],    [4],[5],    [7],        [10],[0,0],[8,9],[3,2]       ], #LEVEL 8
	[         [2],        [5],    [7],        [10],[0,0],[8,9],[3,2],[4,5] ], #LEVEL 9
]

onready var board = get_node("Board")
onready var blink = get_node("Blink")
onready var levelDisplay = get_node("LevelDisplay")
onready var linesDisplay = get_node("LinesDisplay")

onready var sfxPlayer = get_node("/root/SfxPlayer")
onready var scoreKeeper = get_node("/root/ScoreKeeper")

var current_color = "Blue"

var level = 0
var lines = 0
var game_active = false

var event_timer = 20
var event_timer_counter = 0
var previous_event = -1

	
func _physics_process(delta):
	event_timer_counter += delta
	if event_timer_counter>event_timer:
		event_timer_counter = 0
		blink()

func reset_game_manager():
	board = get_node("Board")
	blink = get_node("Blink")
	levelDisplay = get_node("LevelDisplay")
	linesDisplay = get_node("LinesDisplay")
	level = 0
	lines = 0
	event_timer = 15
	event_timer_counter = 0
	previous_event = -1

func increaseLines(i):
	levelDisplay = get_node("LevelDisplay")
	linesDisplay = get_node("LinesDisplay")
	
	var currentLevel = level
	match i:
		1: 
			lines+=1
			sfxPlayer.get_node("1LineSound").play()
		2: 
			lines+=3
			sfxPlayer.get_node("2LinesSound").play()
		3: 
			lines+=5
			sfxPlayer.get_node("3LinesSound").play()
		4: 
			lines+=8
			sfxPlayer.get_node("4LinesSound").play()
		5:
			lines+=10
			sfxPlayer.get_node("4LinesSound").play()
		
	if(currentLevel < min(9,lines/10)):
		levelUp()
	
	linesDisplay.get_node("First/AnimatedSprite").animation  = ((lines/100)%10) as String + current_color 
	linesDisplay.get_node("Second/AnimatedSprite").animation = ((lines/10)%10)  as String + current_color 
	linesDisplay.get_node("Third/AnimatedSprite").animation  = (lines%10)       as String + current_color
	scoreKeeper.score = lines

func levelUp():
	previous_event = -1
	level +=1
	event_timer -= 5/9
	
	if(level == 4):
		changeColors("Green")
	
	if(level == 7):
		changeColors("Red")
		
	levelDisplay.get_node("AnimatedSprite").animation 		 = level 			as String + current_color
		
func changeColors(color):
	for piece in $Board.get_children():
		if piece.block_color == (current_color + "Block"):
			piece.block_color = color
			for block in piece.get_children():
				if(block.isActive):
					block.get_node("AnimatedSprite").play(color + "Block")
	current_color = color
	$Midground.get_node("AnimatedSprite").play(color)
	$Foreground.get_node("AnimatedSprite").play(color)
	$BoardVisual.get_node("AnimatedSprite").play(color)
	$Next.get_node("AnimatedSprite").play(color)
	linesDisplay.get_node("First/AnimatedSprite").animation  = ((lines/100)%10) as String + current_color 
	linesDisplay.get_node("Second/AnimatedSprite").animation = ((lines/10)%10)  as String + current_color 
	linesDisplay.get_node("Third/AnimatedSprite").animation  = (lines%10)       as String + current_color
	levelDisplay.get_node("AnimatedSprite").animation 		 = level 			as String + current_color
	
		
	
func blink():
	blink.get_node("AnimatedSprite").play("Warning")
	yield(blink, "warning_finished")
	blink.get_node("AnimatedSprite").play("Close")
	yield(blink, "close_finished")
	call_random_event()
	blink.get_node("AnimatedSprite").play("Open")

func call_random_event():
	board.resetVisualEvents()
	
	var current_event_pool = eventList[level]
	var event = randi()%(current_event_pool.size())
	while event == previous_event:
		event = randi()%(current_event_pool.size())
		
	for number in current_event_pool[event]:
		match number:
			0:board.removeRandomPiece()
			1:board.disappearMovingPiece()
			2:board.forceQueueTimes4()
			3:board.forceQueuePenta()
			4:board.forceQueueMega()
			5:board.forceHardDrop()
			6:board.hideNext()
			7:board.hideAll()
			8:board.flipCameraX()
			9:board.flipCameraY()
			10:board.allBecomePentas()
	previous_event = event
