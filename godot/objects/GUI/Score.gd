extends Node

onready var MOVES_MODULE = load("res://scripts/ChoiceEnum.gd")
onready var MOVES = MOVES_MODULE.MOVES

onready var score_text_field = get_node("./Score")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#Get the score
	var final_score = MOVES_MODULE.Calculate_Scores(global.player_0_moves, global.player_1_moves)
	var player_0_score = final_score[0]
	var player_1_score = final_score[1]
	var winner = "NONE! NO ONE"
	if player_1_score > player_0_score:
		winner = "2"
	else:
		winner = "1"
	
	#Update the text
	var score_text = score_text_field.get_text()
	score_text += str(player_0_score) + ":" + str(player_1_score)
	score_text += "\n\n Player " + winner + " WINS!"
	score_text_field.set_text(score_text)
	
func _on_Button_pressed():
	#Go back to the main menu
	get_tree().change_scene("res://scenes/MainMenu.tscn")
