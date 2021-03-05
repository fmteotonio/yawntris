extends Node2D

const block_size = 3;

var min_x = 0;
const max_x = 27;
const min_y = 0;
const max_y = 60;

onready var sfxPlayer = get_node("/root/SfxPlayer")
onready var gameManager = get_node("/root/MainGame")

onready var iBlock = preload("res://Scenes/Pieces/I-Block.tscn")
onready var jBlock = preload("res://Scenes/Pieces/J-Block.tscn")
onready var lBlock = preload("res://Scenes/Pieces/L-Block.tscn")
onready var oBlock = preload("res://Scenes/Pieces/O-Block.tscn")
onready var sBlock = preload("res://Scenes/Pieces/S-Block.tscn")
onready var tBlock = preload("res://Scenes/Pieces/T-Block.tscn")
onready var zBlock = preload("res://Scenes/Pieces/Z-Block.tscn")
onready var pPenta = preload("res://Scenes/Pieces/Pentominos/P-Penta.tscn")
onready var iPenta = preload("res://Scenes/Pieces/Pentominos/I-Penta.tscn")
onready var fPenta = preload("res://Scenes/Pieces/Pentominos/F-Penta.tscn")
onready var zPenta = preload("res://Scenes/Pieces/Pentominos/Z-Penta.tscn")
onready var nPenta = preload("res://Scenes/Pieces/Pentominos/N-Penta.tscn")
onready var wPenta = preload("res://Scenes/Pieces/Pentominos/W-Penta.tscn")
onready var tPenta = preload("res://Scenes/Pieces/Pentominos/T-Penta.tscn")
onready var oMega = preload("res://Scenes/Pieces/Megas/O-Mega.tscn")
onready var dMega = preload("res://Scenes/Pieces/Megas/D-Mega.tscn")
onready var allPieces = [iBlock,jBlock,lBlock,oBlock,sBlock,tBlock,zBlock]
onready var allTetras = [iBlock,jBlock,lBlock,oBlock,sBlock,tBlock,zBlock]
onready var allPentas = [pPenta,iPenta,fPenta,zPenta,nPenta,wPenta,tPenta]
onready var allMegas = [oMega,dMega]



onready var grid = []
onready var columns = 10
onready var lines = 22

onready var pieceQueue = []

func _ready():
	randomize()
	for l in lines:
		grid.append([])
		for c in columns:
			grid[l].append(null)
	make_newGrabBag()
	make_newGrabBag()
	callPiece()

func make_newGrabBag():
	allPieces.shuffle()
	for piece in allPieces:
		pieceQueue.append(piece)
		

func addBlock(block, position):
	grid[position.y][position.x] = block

func checkPositionOccupied(position):
	var converted = convertPosition(position)
	return grid[converted.y][converted.x] != null

func checkAllLines():
	var linesToClean = []

	for l in lines:
		var lineIsFull = true
		for c in columns:
			if !grid[l][c]: lineIsFull = false
		if(lineIsFull):
			linesToClean.push_front(l)
	
	var numberLinesToClean = linesToClean.size()
	
	var last_block
	for line in linesToClean:
		var i = 0
		for block in grid[line]:
			last_block = block
			block.get_node("AnimatedSprite").play(block.get_parent().block_color + "Disappear")
	if(linesToClean.size()>0):
		yield(last_block, "disappear_finished")
		
	for line in linesToClean:
		var i = 0
		for block in grid[line]:
			grid[line][i] = null
			var spriteToRemove = block.get_node("AnimatedSprite")
			block.remove_child(block.get_node("AnimatedSprite"))
			spriteToRemove.queue_free()
			block.isActive = false
			i+=1

	if(numberLinesToClean > 0):
		for i in range(numberLinesToClean):
			call_deferred("push_blocks",linesToClean[0],1)
			for ii in linesToClean.size():
				linesToClean[ii] += 1
			linesToClean.remove(0)
	call_deferred("cleanupInactivePieces")
	gameManager.increaseLines(numberLinesToClean)
	
func removeLine(line):
	var i = 0
	for block in grid[line]:
		block.get_node("AnimatedSprite").play(block.get_node("AnimatedSprite").animation + "Disappear")
		yield(block, "disappear_finished")
		grid[line][i] = null
		var spriteToRemove = block.get_node("AnimatedSprite")
		block.remove_child(block.get_node("AnimatedSprite"))
		spriteToRemove.queue_free()
		block.isActive = false
		i+=1
		
func push_blocks(line,pushes):
	var blocks_to_push = []
	for l in range(line,0,-1):
		for c in columns:
			if(grid[l][c] != null):
				var block = grid[l][c]
				blocks_to_push.append([l,c,block])
		
	for a in blocks_to_push:
		var l = a[0]
		var c = a[1]
		var block = a[2]
		grid[l][c] = null
		grid[l+pushes][c] = block
		block.global_position.y += pushes*block_size

func cleanupInactivePieces():
	for piece in get_children():
		var toDelete = true
		for block in piece.get_children():
			if block.isActive:
				toDelete = false
		if toDelete:
			remove_child(piece)
			piece.queue_free()
		
func place_piece(piece):
	for block in piece.get_children():
		var converted = convertPosition(piece.position + block.position)
		addBlock(block, converted)
	call_deferred("checkAllLines")
	call_deferred("callPiece")
		
func convertPosition(position):
		var position_x = position.x/block_size
		var position_y = position.y/block_size-1
		return Vector2(position_x, position_y)
		
func callPiece():
	#Create new Piece
	var newPiece = pieceQueue[0].instance()
	self.add_child(newPiece)
	newPiece.position = newPiece.initial_position
	newPiece.is_movable = true
	
	#Update Piece Queue
	pieceQueue.remove(0)
	if(pieceQueue.size()<7):
		make_newGrabBag()
	
	#Remove previous Next piece
	replaceNext(pieceQueue[0])
	
	
func replaceNext(pieceFromQueue):
	#Remove previous Next piece
	for n in get_node("../Next/NextPiece").get_children():
		get_node("../Next/NextPiece").remove_child(n)
		n.queue_free()
	#Add new Next Piece
	var newNext = pieceFromQueue.instance()
	newNext.is_movable = false
	newNext.position = newNext.initial_next_position
	get_node("../Next/NextPiece").add_child(newNext)

#---------------------EVENTS---------------------------

func removeRandomPiece(): 
	if(get_child_count()>0):
		var piece = get_children()[randi()%get_children().size()]
		if !piece.is_movable:
			for block in piece.get_children():
				remove_child(piece)
				piece.queue_free()
			
func disappearMovingPiece():
	for piece in get_children():
		if piece.is_movable:
			remove_child(piece)
			piece.queue_free()
	callPiece()
	
func forceQueuePenta():
	allPentas.shuffle()
	pieceQueue.push_front(allPentas[0])
	replaceNext(allPentas[0])
	
func forceQueueMega():
	allMegas.shuffle()
	pieceQueue.push_front(allMegas[0])
	replaceNext(allMegas[0])
	
func forceQueueTimes4():
	pieceQueue.push_front(pieceQueue[0])
	pieceQueue.push_front(pieceQueue[0])
	pieceQueue.push_front(pieceQueue[0])
	
func forceHardDrop():
	for piece in get_children():
		if piece.is_movable:
			piece.hard_drop(false)
			
func hideNext():
	get_node("../Next").hide()
		
func hideAll():
	get_node("../Next").hide()
	get_node("../BoardVisual").hide()
	get_node("../LevelDisplay").hide()
	get_node("../LinesDisplay").hide()
	get_node("../Foreground").hide()
	get_node("../Midground").hide()

func flipCameraX():
	get_node("../MainCamera").zoom.x = -1
	
func flipCameraY():
	get_node("../MainCamera").zoom.y = -1
	
func allBecomePentas():
	allPieces = allPentas
	pieceQueue = []
	make_newGrabBag()
	allPieces = allTetras
	replaceNext(pieceQueue[0])

func resetVisualEvents():
	get_node("../Next").show()
	get_node("../BoardVisual").show()
	get_node("../LevelDisplay").show()
	get_node("../LinesDisplay").show()
	get_node("../Foreground").show()
	get_node("../Midground").show()
	get_node("../MainCamera").zoom = Vector2(1,1)
		
