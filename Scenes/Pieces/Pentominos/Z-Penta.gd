extends "res://Scenes/MainScenes/Piece.gd"

var initial_position = Vector2(9,-3)
var initial_next_position = Vector2(47,2)

func _init():
	var pos0 = [Vector2(1,3),Vector2(1,2),Vector2(2,2),Vector2(3,2),Vector2(3,1)]
	var pos1 = [Vector2(1,1),Vector2(2,1),Vector2(2,2),Vector2(2,3),Vector2(3,3)]
	var pos2 = [Vector2(1,3),Vector2(1,2),Vector2(2,2),Vector2(3,2),Vector2(3,1)]
	var pos3 = [Vector2(1,1),Vector2(2,1),Vector2(2,2),Vector2(2,3),Vector2(3,3)]
	positions = [pos0,pos1,pos2,pos3]
	block_color = "YellowBlock"
	
	wallKicks = {
		"01": [Vector2(0,0),Vector2(-1,0),Vector2(-1,-1),Vector2(0, 2),Vector2(-1, 2)], 
		"10": [Vector2(0,0),Vector2( 1,0),Vector2( 1, 1),Vector2(0,-2),Vector2( 1,-2)],
		"12": [Vector2(0,0),Vector2( 1,0),Vector2( 1, 1),Vector2(0,-2),Vector2( 1,-2)],
		"21": [Vector2(0,0),Vector2(-1,0),Vector2(-1,-1),Vector2(0, 2),Vector2(-1, 2)],
		"23": [Vector2(0,0),Vector2( 1,0),Vector2( 1,-1),Vector2(0, 2),Vector2( 1, 2)],
		"32": [Vector2(0,0),Vector2(-1,0),Vector2(-1, 1),Vector2(0,-2),Vector2(-1,-2)],
		"30": [Vector2(0,0),Vector2(-1,0),Vector2(-1, 1),Vector2(0,-2),Vector2(-1,-2)],
		"03": [Vector2(0,0),Vector2( 1,0),Vector2( 1,-1),Vector2(0, 2),Vector2( 1, 2)],
	}

func _ready():
	for block in get_children():
		block.get_node("AnimatedSprite").animation = block_color
