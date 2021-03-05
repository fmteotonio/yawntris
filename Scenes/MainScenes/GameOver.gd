extends Node2D

onready var scoreKeeper = get_node("/root/ScoreKeeper")

func _ready():
	$LinesDisplay.get_node("First/AnimatedSprite").animation  = ((scoreKeeper.score/100)%10) as String + "Blue"
	$LinesDisplay.get_node("Second/AnimatedSprite").animation = ((scoreKeeper.score/10)%10)  as String + "Blue"
	$LinesDisplay.get_node("Third/AnimatedSprite").animation  = (scoreKeeper.score%10)       as String + "Blue"

func _process(delta):
	if(Input.is_action_just_pressed("ui_start") or Input.is_action_just_pressed("ui_rotate_right") or Input.is_action_just_pressed("ui_rotate_left")):
		print("yo")
		get_tree().change_scene("res://Scenes/MainScenes/TitleScreen.tscn")

