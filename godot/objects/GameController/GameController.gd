extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Find the players
onready var player_0 = find_node("../Player0")
onready var player_1 = find_node("../Player1")

#Is player 1 AI?
var player_1_AI = false
var player_1_difficulty = false

#Stuff related to rounds
var current_round = 0
var total_rounds = 50

#Stuff related to tempo and music
var start_tempo = 60 #BPM
var current_tempo = start_tempo
var tempo_increase_cadence = 5 #How many rounds
var tempo_increase_amount = 10 #BPM

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	#Lets update player 1 if needed
	if player_1_AI:
		player_1.AI = true
		player_1.AI_DIFFICULTY = player_1_difficulty
	
	pass
