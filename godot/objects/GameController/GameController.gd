extends Sprite

onready var MOVES_MODULE = load("res://scripts/ChoiceEnum.gd")
onready var MOVES = MOVES_MODULE.MOVES

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Find the players
onready var player_0 = get_node("../Player0")
onready var player_1 = get_node("../Player1")
onready var timer = get_node("./Timer")

#Debug
onready var debug_text = get_node("./TimeDebug")

#Is player 1 AI?
var player_1_AI = true
var player_1_difficulty = true

#Stuff related to rounds
var current_round = 0
var total_rounds = 50
var latest_winner = null
var latest_player0_move = null
var latest_player1_move = null

#Stuff related to tempo and music
var start_tempo = 60 #BPM
var current_tempo = start_tempo
var tempo_increase_cadence = 4 #How many rounds
var tempo_increase_amount = 20 #BPM
var beat_count = 0

#Sounds
onready var tone = load("res://objects/GameController/tone.ogg")
onready var tone2 = load("res://objects/GameController/tone2.ogg")
onready var player_0_win = load("res://objects/GameController/player_0_win.ogg")
onready var player_1_win = load("res://objects/GameController/player_1_win.ogg")
onready var lose = load("res://objects/GameController/lose.ogg")
onready var sfx = get_node("./SFX")

#Some sprites
onready var sprite_player_0_win = load("res://objects/GameController/player_0_win.png")
onready var sprite_player_1_win = load("res://objects/GameController/player_1_win.png")
onready var sprite_no_win = load("res://objects/GameController/no_win.png")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	#grab the player setup
	player_1_AI = global.player_1_AI
	player_1_difficulty = global.player_1_difficulty
	
	#Lets update player 1 if needed
	player_1.call_deferred("set_AI", player_1_AI, player_1_difficulty)
	
	#Set the AI for both for now
	#player_0.call_deferred("set_AI", true, false)
	
	
	#Kick off the timer
	timer.set_one_shot(true)
	timer.connect("timeout", self, "_on_timer_timeout_tempo")
	handle_timer()

func handle_timer():
	#How long till the next beat?
	var beat_time = 60.0 / current_tempo
	
	#And increment the counter and set the time
	timer.set_wait_time(beat_time)
	
	#Fire off the timer
	timer.start()
	
	#Update some debug stuff here
	var text = "R:" + str(current_round) + " B:" + str(beat_count) + " T:" + str(current_tempo)
	debug_text.set_text(text)
	
func _on_timer_timeout_tempo():
	#Which beat were we on?
	if beat_count == 0:
		#We can play the noise
		sfx.set_stream(tone)
		set_texture(null)
		
		#Reset player sprites
		player_0.change_sprite(MOVES.NEUTRAL)
		player_1.change_sprite(MOVES.NEUTRAL)
		
	elif beat_count == 1:
		#Play the same noise
		sfx.set_stream(tone)
	elif beat_count == 2:
		#Play the different noise
		sfx.set_stream(tone2)
		
		#We need to get the moves for each player
		#Also reset their moves
		latest_winner = get_winner()
		
	elif beat_count == 3:
		
		#Let the players show what they picked
		player_0.change_sprite(latest_player0_move)
		player_1.change_sprite(latest_player1_move)
		
		#Updade the AI if needed
		player_0.give_result_AI(latest_player1_move)
		player_1.give_result_AI(latest_player0_move)
		
		#Play the sound for the winner
		if latest_winner == null:
			#No one wins!
			sfx.set_stream(lose)
			set_texture(sprite_no_win)
		elif not latest_winner:
			#Player 0 won
			sfx.set_stream(player_0_win)
			set_texture(sprite_player_0_win)
		else:
			#Player 1 win
			sfx.set_stream(player_1_win)
			set_texture(sprite_player_1_win)
		
		#Did we finish the game?
		current_round += 1
		if current_round >= total_rounds:
			#We're done
			get_tree().change_scene("res://scenes/Score.tscn")
			return
		
		#Do we increase tempo?
		if current_round % tempo_increase_cadence == 0:
			current_tempo += tempo_increase_amount
		
		#Reset the counter
		beat_count = -1
	
	#Play the appropriate sound
	sfx.play()
	
	#Increment beat and fire off the timer again
	beat_count += 1
	handle_timer()
	
func get_winner():
	
	#What did each player choose?
	latest_player0_move = player_0.get_move()
	latest_player1_move = player_1.get_move()
	
	#Update the history
	global.player_0_moves.append(latest_player0_move)
	global.player_1_moves.append(latest_player1_move)
	
	#Did player 0 win?
	var player0_winner = MOVES_MODULE.Move_Wins(latest_player0_move, latest_player1_move)
	return player0_winner