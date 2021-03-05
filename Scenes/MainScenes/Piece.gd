extends Node2D

const block_size = 3;

onready var board = get_parent()
onready var gameManager = get_node("/root/MainGame")
onready var sfxPlayer = get_node("/root/SfxPlayer")



onready var is_movable = false;
onready var step_time_base = 1.0;
onready var step_time = 1;
onready var step_time_counter = 0;
onready var down_time = 0.07;
onready var down_time_counter = 0;
onready var hor_time = 0.07;
onready var hor_time_counter = 0;
onready var horlock_time = 0.2;
onready var horlock_time_counter = 0;

onready var actual_position = 0
onready var positions; #Define in subclass
onready var wallKicks; #Define in subclass
onready var block_color

#Devolve array com as posições atuais de todos os blocos
func get_position_array():
	var my_position_array = []
	for block in get_children():
		my_position_array.append(position + block.position)
	return my_position_array

func _process(delta):
	step_time = step_time_base / (1 + (0.6*(gameManager.level+1.0)))
	
	if(is_movable):
		step_time_counter += delta;
		down_time_counter += delta;
		hor_time_counter  += delta;
		
		if(!check_valid_position(get_position_array())):
			sfxPlayer.get_node("LoseGameSound").play()
			get_tree().change_scene("res://Scenes/MainScenes/GameOver.tscn")
			return
		
		
		if(Input.is_action_just_pressed("ui_rotate_left")):
			attempt_rotation(-1)
		if(Input.is_action_just_pressed("ui_rotate_right")):
			attempt_rotation(1)
		
		
		if(Input.is_action_just_pressed("ui_left")):
			if(check_valid_position(apply_movement(Vector2(-1,0), get_position_array()))):
					move(Vector2(-1,0))
					hor_time_counter = 0
		elif(Input.is_action_just_pressed("ui_right")):
			if(check_valid_position(apply_movement(Vector2(1,0), get_position_array()))):
					move(Vector2(1,0))
					hor_time_counter = 0
		
		if(Input.is_action_pressed("ui_left")):
			horlock_time_counter += delta
			if(hor_time_counter > hor_time and horlock_time_counter > horlock_time):
				if(check_valid_position(apply_movement(Vector2(-1,0), get_position_array()))):
					move(Vector2(-1,0))
					hor_time_counter = 0
		elif(Input.is_action_pressed("ui_right")):
			horlock_time_counter += delta
			if(hor_time_counter > hor_time and horlock_time_counter > horlock_time):
				if(check_valid_position(apply_movement(Vector2(1,0), get_position_array()))):
					move(Vector2(1,0))
					hor_time_counter = 0
		else:
			horlock_time_counter = 0;
		
		if(Input.is_action_pressed("ui_down")):
			if(down_time_counter > down_time):
				down_time_counter = 0
				if(check_valid_position(apply_movement(Vector2(0,1), get_position_array()))):
					step_time_counter = 0;
					move(Vector2(0,1))
					
		if(Input.is_action_just_pressed("ui_up")):
				hard_drop(true)
				return
					
		if(step_time_counter > step_time):
			step_time_counter = 0;
			if(check_valid_position(apply_movement(Vector2(0,1), get_position_array()))):
				move(Vector2(0,1))
			else:
				is_movable = false
				sfxPlayer.get_node("PiecePlaceSound").play()
				for block in get_children():
					block.get_node("AnimatedSprite").play(block_color+"Shine")
				get_parent().place_piece(self)
				
func hard_drop(playSound):
	var yPosition = 0
	while(is_movable == true):
		if(!check_valid_position(apply_movement(Vector2(0,yPosition+1), get_position_array()))):
			move(Vector2(0,yPosition))
			is_movable = false
			if playSound: sfxPlayer.get_node("PiecePlaceSound").play()
			for block in get_children():
				block.get_node("AnimatedSprite").play(block_color+"Shine")
			get_parent().place_piece(self)
			return
		yPosition += 1

#Executa um ciclo de testes de wallkicks e aplica a primeira rotação e movimento que passar nos testes
func attempt_rotation(direction):
	var next_position = actual_position + direction
	if(next_position > 3):   next_position = 0
	elif(next_position < 0): next_position = 3

	var rotation_id = actual_position as String + next_position as String
	var testNumber = 0
	while(testNumber<5):
		if(check_valid_position(apply_movement(wallKicks[rotation_id][testNumber],apply_rotation(positions[next_position])))):
			rotate(positions[next_position])
			move(wallKicks[rotation_id][testNumber])
			actual_position = next_position
			sfxPlayer.get_node("RotateSound").play()
			break
		else:
			testNumber +=1

#Devolve conjunto de posições enviadas com o movimento aplicado
func apply_movement(movement_vector, position_array):
	var new_position_array = []
	for block_position in position_array:
		new_position_array.append(block_position + movement_vector*block_size)
	return new_position_array

#Já sabendo que um movimento é valido, move o bloco todo numa direcção
func move(movement_vector):
	position += movement_vector * block_size

#Devolve posições atuais dos blocos com a rotação enviada aplicada
func apply_rotation(rotation_array):
	var new_position_array = []
	for block_position in rotation_array:
		new_position_array.append(position + block_position * block_size)
	return new_position_array

#Já sabendo que a rotação é valida, muda só a posição dos blocos para as novas posições
func rotate(position_array):
	var i = 0
	for block in get_children():
		block.position = position_array[i] * block_size
		i+=1

##-------------------------------------------------------------------------------------------

#Verifica se um conjunto de 4 posições é válido ou não
func check_valid_position(position_array):
	var valid_move = true
	for block_position in position_array:
		if(!is_inside_board(block_position) or board.checkPositionOccupied(block_position)): #Mais condições depois mete-se ands aqui
			valid_move = false
	return valid_move

#Condição 1:
#Recebe um par de coordenadas e vê se tá dentro do tabuleiro
func is_inside_board(position):
	return position.x >= board.min_x and position.x <= board.max_x and position.y <= board.max_y
