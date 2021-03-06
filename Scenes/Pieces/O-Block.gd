extends "res://Scenes/MainScenes/Piece.gd"

var initial_position = Vector2(12,-3)
var initial_next_position = Vector2(53,5)

func _init():
	var pos0 = [Vector2(0,0),Vector2(0,1),Vector2(1,0),Vector2(1,1)]
	var pos1 = [Vector2(0,0),Vector2(0,1),Vector2(1,0),Vector2(1,1)]
	var pos2 = [Vector2(0,0),Vector2(0,1),Vector2(1,0),Vector2(1,1)]
	var pos3 = [Vector2(0,0),Vector2(0,1),Vector2(1,0),Vector2(1,1)]
	positions = [pos0,pos1,pos2,pos3]
	block_color = "WhiteBlock"
	
	wallKicks = {
		"01": [Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2( 0, 0)], 
		"10": [Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2( 0, 0)],
		"12": [Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2( 0, 0)],
		"21": [Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2( 0, 0)],
		"23": [Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2( 0, 0)],
		"32": [Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2( 0, 0)],
		"30": [Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2( 0, 0)],
		"03": [Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2(0, 0),Vector2( 0, 0)],
	}

func _ready():
	for block in get_children():
		block.get_node("AnimatedSprite").animation = block_color
