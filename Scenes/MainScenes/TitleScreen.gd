extends Node2D

onready var sfxPlayer = get_node("/root/SfxPlayer")

func _ready():
	sfxPlayer.get_node("CricketSound").play()

func _process(delta):
	if(Input.is_action_just_pressed("ui_start")):
		sfxPlayer.get_node("StartGameSound").play()
		get_tree().change_scene("res://Scenes/MainScenes/MainGame.tscn")
