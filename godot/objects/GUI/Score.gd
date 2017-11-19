extends Node

onready var MOVES_MODULE = load("res://scripts/ChoiceEnum.gd")
onready var MOVES = MOVES_MODULE.MOVES

onready var score_text_field = get_node("./Score")
var score_text = "[color=#000000]Final Score:[/color]\n\n[color=#00FF00]Player1[/color][color=#000000] Vs. [/color][color=#0000FF]Player2[/color]\n"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#Get the score
	var final_score = MOVES_MODULE.Calculate_Scores(global.player_0_moves, global.player_1_moves)
	var player_0_score = final_score[0]
	var player_1_score = final_score[1]
	var winner = "[color=#FF0000]NONE! NO ONE"
	if player_1_score > player_0_score:
		winner = "[color=#0000FF]2"
	else:
		winner = "[color=#00FF00]1"
	winner += "[/color]"
	
	#Update the text
	score_text += "[color=#00FF00]" + str(player_0_score) + "[/color][color=#000000]:[/color][color=#0000FF]" + str(player_1_score) + "[/color]"
	score_text += "\n\n [color=#000000]Player [/color]" + winner + " [color=#000000]WINS![/color]"
	score_text_field.set_bbcode(score_text)
	
func _on_Button_pressed():
	#Go back to the main menu
	get_tree().change_scene("res://scenes/MainMenu.tscn")

