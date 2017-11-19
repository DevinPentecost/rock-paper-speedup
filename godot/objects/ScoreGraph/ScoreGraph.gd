extends Position2D

onready var MOVES_MODULE = load("res://scripts/ChoiceEnum.gd")
onready var MOVES = MOVES_MODULE.MOVES
onready var PLAYERS = load("res://scripts/Players.gd")


onready var timer = get_node("./Timer")
var update_time = 1.0/3.0
var current_round = 0

var col_width = 10
var row_height = 10

var start_x = null
var start_y = null
var results = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	#Set up the timer
	timer.set_wait_time(update_time)
	timer.start()
	
	#Get the starting position
	var total_moves = global.player_0_moves.size()
	var current_position = get_pos()
	start_y = 0
	start_x = -(col_width*total_moves)/2
	
	
	#Get the scores for the game
	results = MOVES_MODULE.Get_Results_Per_Round(global.player_0_moves, global.player_1_moves)

func _draw():
	#For each round...
	for move_index in range(0, current_round):
		
		#Get the x position to start drawing
		var current_x = start_x + (col_width * move_index)
		
		#Get the current score at that point
		var move_results = results[move_index]
		var winner = move_results[0]
		var player_0_score = move_results[1]
		var player_1_score = move_results[2]
		
		#What color to use
		var col_color = Color(1, 0, 1)
		if winner == null:
			col_color = global.LOSERS_COLOR
		elif winner:
			col_color = global.PLAYER_0_COLOR
		else:
			col_color = global.PLAYER_1_COLOR
		
		#Get the height of the column
		var col_height = (player_1_score - player_0_score) * row_height
		
		#Draw that rect
		var rect = [Vector2(current_x, start_y), Vector2(current_x + col_width, start_y), Vector2(current_x + col_width, start_y + col_height), Vector2(current_x, start_y + col_height)]
		draw_polygon(rect, [col_color])
		
	#Draw a line across the middle
	draw_line(Vector2(start_x, start_y), Vector2(start_x + (col_width * global.player_0_moves.size()), start_y), Color(0.5, 0.5, 0.5), 2)

func _on_Timer_timeout():
	
	#We need to update what we are drawing
	current_round += 1
	
	#Are we done?
	if current_round >= global.player_0_moves.size():
		#We are done
		timer.stop()
	
	#Redraw
	update()