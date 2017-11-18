extends Sprite

onready var MOVES = load("res://scripts/ChoiceEnum.gd").MOVES

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Get the controller
onready var player_controller = get_node("./PlayerInputController")

#Get the sprite
onready var neutral_sprite = load("res://objects/Player/player_neutral.png")
onready var rock_sprite = load("res://objects/Player/player_rock.png")
onready var paper_sprite = load("res://objects/Player/player_paper.png")
onready var scissors_sprite = load("res://objects/Player/player_scissors.png")

#Player states
var player_move = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player_move = MOVES.NEUTRAL
	
func get_move():
	player_move = player_controller.get_move(true)
	return player_move

func give_result_AI(move):
	player_controller.give_result_AI(move)

func change_sprite(move):
	
	#Which was selected?
	if move == MOVES.NEUTRAL:
		set_texture(neutral_sprite)
	elif move == MOVES.ROCK:
		set_texture(rock_sprite)
	elif move == MOVES.PAPER:
		set_texture(paper_sprite)
	elif move == MOVES.SCISSORS:
		set_texture(scissors_sprite)
	else:
		#Just stay I guess
		pass
	
func set_AI(is_AI, is_difficult):
	player_controller.AI = is_AI
	player_controller.AI_SMART = is_difficult
	
