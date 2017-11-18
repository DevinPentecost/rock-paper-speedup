extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var check_button = get_node("./CheckButton")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_OnePlayer_Button_pressed():
	global.player_1_AI = true
	global.player_1_difficulty = check_button.is_pressed()
	start_game()

func _on_TwoPlayer_Button_pressed():
	#No need for AI
	global.player_1_AI = false
	global.player_1_difficulty = false
	start_game()

func start_game():
	#We need to reset the history
	global.clear_history()
	
	#Start the next scene
	get_tree().change_scene("res://scenes/Game.tscn")