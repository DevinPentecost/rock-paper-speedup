extends Node

onready var MOVES = load("res://scripts/ChoiceEnum.gd").MOVES

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

func set_move(move_index):
	current_move = possible_moves[move_index]
	
func give_result_AI(opponent_choice):
	OPPONENT_HISTORY.append(opponent_choice)

func get_move():
	#Are we an AI?
	if AI:
		#We need to get one via AI
		return get_move_AI(AI_SMART)
		
func get_move_AI(difficulty):
	
	#What kind of AI?
	if not AI_SMART:
		#Random choice
		return possible_moves[randi() % possible_moves.size()]
	else:
		#We need to get it based on our odds
		var total_moves = OPPONENT_HISTORY.size()
		if total_moves == 0:
			#We have no data, just act dumb
			return get_move_AI(false)
		
		#Calculate odds
		var odds_rock = (OPPONENT_HISTORY.count(MOVES.ROCK) / total_moves)
		var odds_paper = (OPPONENT_HISTORY.count(MOVES.PAPER) / total_moves)
		var odds_scissors = (OPPONENT_HISTORY.count(MOVES.SCISSORS) / total_moves)
		var all_odds = [odds_rock, odds_paper, odds_scissors]
		
		#Pick one
		var random = randf()
		var current = 0
		for index in range(0, all_odds.size()):
			#Check the odds
			var odds = all_odds[index]
			if current + odds >= random:
				return possible_moves[index]
			
			#Keep counting
			current += odds
		
		#For some reason we failed
		return MOVES.NEUTRAL
