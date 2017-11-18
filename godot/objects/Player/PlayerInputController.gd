extends Node

onready var MOVES_MODULE = load("res://scripts/ChoiceEnum.gd")
onready var MOVES = MOVES_MODULE.MOVES

#Which player are we?
var current_player = 0

#Are we an AI?
var AI = false #Controlled by a player or not?
var AI_SMART = false #Easy or hard?
var OPPONENT_HISTORY = []

var possible_moves = null
var current_move = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	current_move = MOVES.NEUTRAL
	
	#Set up the moves
	possible_moves = [
	MOVES.ROCK,
	MOVES.PAPER,
	MOVES.SCISSORS
	]
	
	#Wait for input events
	set_process_input(true)

func set_move(move_index):
	current_move = possible_moves[move_index]
	
func give_result_AI(opponent_choice):
	OPPONENT_HISTORY.append(opponent_choice)

func get_move(reset=true):
	#Are we an AI?
	var active_move = MOVES.NEUTRAL
	if AI:
		#We need to get one via AI
		active_move = get_move_AI(AI_SMART)
	else:
		active_move = current_move
	
	#Should we reset it too?
	if reset:
		current_move = MOVES.NEUTRAL
	
	#Return that move
	return active_move
	
func get_move_AI(difficulty):
	
	#What kind of AI?
	if not difficulty:
		#Random choice
		return possible_moves[randi() % possible_moves.size()]
	else:
		#We need to get it based on our odds
		var total_moves = OPPONENT_HISTORY.size()
		if total_moves == 0:
			#We have no data, just act dumb
			return get_move_AI(false)
		
		#Calculate odds
		var odds_rock = (1.0 * OPPONENT_HISTORY.count(MOVES.ROCK) / total_moves)
		var odds_paper = (1.0 * OPPONENT_HISTORY.count(MOVES.PAPER) / total_moves)
		var odds_scissors = (1.0 * OPPONENT_HISTORY.count(MOVES.SCISSORS) / total_moves)
		var all_odds = [odds_rock, odds_paper, odds_scissors]
		
		#Pick one
		var random = randf()
		var current = 0
		for index in range(0, all_odds.size()):
			#Check the odds
			var odds = all_odds[index]
			if current + odds >= random:
				return MOVES_MODULE.Find_Winning_Move(possible_moves[index])
			
			#Keep counting
			current += odds
		
		#For some reason we failed
		return MOVES.NEUTRAL


func _input(input_event):
	
	#Check the input key
	if input_event.type == InputEvent.KEY:
		if current_player == 0:
			if input_event.is_action_pressed("player_0_r"):
				current_move = MOVES.ROCK
			elif input_event.is_action_pressed("player_0_p"):
				current_move = MOVES.PAPER
			elif input_event.is_action_pressed("player_0_s"):
				current_move = MOVES.SCISSORS
		if current_player == 1:
			if input_event.is_action_pressed("player_1_r"):
				current_move = MOVES.ROCK
			elif input_event.is_action_pressed("player_1_p"):
				current_move = MOVES.PAPER
			elif input_event.is_action_pressed("player_1_s"):
				current_move = MOVES.SCISSORS