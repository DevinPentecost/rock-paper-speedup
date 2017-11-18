extends Sprite

onready var MOVES = load("res://scripts/ChoiceEnum.gd").MOVES

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

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
	
func set_move(move):
	player_move = move

func change_sprite():
	
	#Which was selected?
	if player_move == MOVES.NEUTRAL:
		set_texure(neutral_sprite)
	elif player_move == MOVES.ROCK:
		set_texture(rock_sprite)
	elif player_move == MOVES.PAPER:
		set_texture(paper_sprite)
	elif player_move == MOVES.SCISSORS:
		set_texture(scissors_sprite)
	else:
		#Just stay I guess
		pass
	
	
