extends "res://Scenes/MainScenes/Piece.gd"

var initial_position = Vector2(9,-3)
var initial_next_position = Vector2(50,2)

func _init():
	var pos0 = [Vector2(2,0),Vector2(2,1),Vector2(2,2),Vector2(2,3),Vector2(2,4),Vector2(0,2),Vector2(1,2),Vector2(3,2),Vector2(4,2)]
	var pos1 = [Vector2(2,0),Vector2(2,1),Vector2(2,2),Vector2(2,3),Vector2(2,4),Vector2(0,2),Vector2(1,2),Vector2(3,2),Vector2(4,2)]
	var pos2 = [Vector2(2,0),Vector2(2,1),Vector2(2,2),Vector2(2,3),Vector2(2,4),Vector2(0,2),Vector2(1,2),Vector2(3,2),Vector2(4,2)]
	var pos3 = [Vector2(2,0),Vector2(2,1),Vector2(2,2),Vector2(2,3),Vector2(2,4),Vector2(0,2),Vector2(1,2),Vector2(3,2),Vector2(4,2)]
	positions = [pos0,pos1,pos2,pos3]
	block_color = "RedBlock"
	
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
